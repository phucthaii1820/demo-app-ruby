# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  include RackSessionsFix

  def create
    self.resource = warden.authenticate(auth_options)
    if resource
      sign_in(resource_name, resource)
      respond_with(resource, {})
    else
      render json: {
        status: 401,
        message: "Invalid email or password.",
        data: {}
      }, status: :unauthorized
    end
  end

  private
  def respond_with(current_user, _opts = {})
    render json: {
      status: {
        code: 200, message: "Logged in successfully.",
        data: {
            user: UserSerializer.new(current_user).serializable_hash[:data][:attributes]
        }
      }
    }, status: :ok
  end
  def respond_to_on_destroy
    if current_user
      render json: {
        status: 200,
        message: "Logged out successfully.",
        data: {}
      }, status: :ok
    else
      render json: {
        status: 401,
        message: "Couldn't find an active session.",
        data: {}
      }, status: :unauthorized
    end
  end
end
