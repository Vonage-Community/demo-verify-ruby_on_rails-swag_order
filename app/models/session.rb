class Session < ApplicationRecord
  belongs_to :user

  def two_factor_authenticated?
    two_factor_authenticated
  end
end
