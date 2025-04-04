class AddTwoFactorAuthenticatedToSessions < ActiveRecord::Migration[8.0]
  def change
    add_column :sessions, :two_factor_authenticated, :boolean, default: false
  end
end
