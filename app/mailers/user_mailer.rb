class UserMailer < ApplicationMailer
  default from: ENV["DEFAULT_EMAIL_FROM"]

  def welcome_email(user)
    @user = user
    mail(
      to: @user.email,
      subject: "Welcome to Our App",
      body: "Hello #{@user.name}, welcome to our platform!"
    )
  end
end
