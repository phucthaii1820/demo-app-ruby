class SendWelcomeEmailJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # user = User.find_by(id: user_id)
    # return unless user

    # UserMailer.welcome_email(user).deliver_now
    Rails.logger.info "Sending welcome email to user with ID: #{args.first}"
    user = User.find_by(id: args.first)
    if user
      UserMailer.welcome_email(user).deliver_now
      Rails.logger.info "Welcome email sent to user with ID: #{args.first}"
    else
      Rails.logger.error "User with ID: #{args.first} not found. Email not sent."
    end
  end
end
