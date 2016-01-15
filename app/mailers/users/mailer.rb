class Users::Mailer < ActionMailer::Base
  default from: "noreply@quotiful.com"

  def reset_password_instructions(user_id)
    @user = User.find(user_id)
    @user.set_reset_password_token!

    mail(to: @user.email, subject: "Password reset on Quotiful")
  end

  def deactivation(user_id)
    @user = User.find(user_id)

    mail(to: @user.email, subject: "Quotiful Account Deactivated")
  end
end
