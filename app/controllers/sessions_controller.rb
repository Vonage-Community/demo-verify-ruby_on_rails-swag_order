class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create edit update request_new_otp ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
  end

  def create
    if user = User.authenticate_by(params.permit(:username, :password))
      start_new_session_for user
      send_otp_to user
      redirect_to edit_session_path, notice: 'Check your phone for the OTP.'
    else
      redirect_to new_session_path, alert: "Try another username or password."
    end
  end

  def update
    session = find_session_by_cookie
    otp_response_code = check_otp(params[:otp])
    if session && otp_valid?(otp_response_code)
      session.update(two_factor_authenticated: true)
      redirect_to after_authentication_url, notice: 'Successfully signed in.'
    else
      alert_text = set_invalid_otp_alert_text(otp_response_code)
      redirect_to edit_session_path, alert: alert_text
    end
  end

  def edit
  end

  def destroy
    terminate_session
    redirect_to new_session_path, notice: 'Successfully signed out.'
  end

  def request_new_otp
    session = resume_session
    send_otp_to session.user
    redirect_to edit_session_path, notice: 'New OTP sent. Check your phone for the OTP.'
  end
end
