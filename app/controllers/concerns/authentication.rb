module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
    helper_method :authenticated?
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end
  end

  private
    def authenticated?
      session = resume_session
      session && session.two_factor_authenticated?
    end

    def require_authentication
      session = resume_session
      session && session.two_factor_authenticated? || request_authentication
    end

    def resume_session
      Current.session ||= find_session_by_cookie
    end

    def find_session_by_cookie
      Session.find_by(id: cookies.signed[:session_id]) if cookies.signed[:session_id]
    end

    def request_authentication
      session[:return_to_after_authenticating] = request.url
      redirect_to new_session_path, :alert => "You must be logged in to perform this action / この操作を行うにはログインが必要です。"
    end

    def after_authentication_url
      session.delete(:return_to_after_authenticating) || root_url
    end

    def start_new_session_for(user)
      user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip).tap do |session|
        Current.session = session
        cookies.signed.permanent[:session_id] = { value: session.id, httponly: true, same_site: :lax }
      end
    end

    def terminate_session
      Current.session.destroy
      cookies.delete(:session_id)
    end

    def send_otp_to(user)
      unless session[:two_factor_verification_request_id].nil?
        begin
          Vonage.verify2.cancel_verification_request(request_id: session[:two_factor_verification_request_id])
        rescue Vonage::APIError => error
          logger.debug error.http_response_code
        end
      end

      verification_workflow = Vonage.verify2.workflow
      verification_workflow << verification_workflow.sms(to: Current.user.phone_number)
      begin
        response = Vonage.verify2.start_verification(brand: 'Vonage Dev', workflow: verification_workflow.hashified_list)
        session[:two_factor_verification_request_id] = response.request_id
      rescue Vonage::APIError => error
        logger.debug error.http_response_code
        logger.debug error.http_response_body
      end
    end

    def check_otp(otp)
      begin
        code_check_request = Vonage.verify2.check_code(request_id: session[:two_factor_verification_request_id], code: otp)
        code_check_request.http_response.code
      rescue Vonage::Error => error
        error.http_response.code
      end
    end

    def otp_valid?(response_code)
      response_code == '200'
    end

    def set_invalid_otp_alert_text(otp_response_code)
      case otp_response_code
      when '400'
        'The code you entered is invalid.'
      when '404'
        'The code you entered has expired.'
      when '410'
        'You have reached the maximum number of attempts.'
      else
        'Sorry, something went wrong. Please try again later.'
      end
    end
end
