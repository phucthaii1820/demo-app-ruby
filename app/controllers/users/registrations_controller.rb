# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionsFix

  def update
    if params[:user][:new_password].present?
      unless current_user.valid_password?(params[:user][:current_password])
        return render json: {
          status: { code: 401, message: "Current password is incorrect." },
          data: {}
        }, status: :unauthorized
      end

      if current_user.update(name: params[:user][:name], password: params[:user][:new_password])
        render json: {
          status: { code: 200, message: "Name and password updated successfully." },
          data: UserSerializer.new(current_user).serializable_hash[:data][:attributes]
        }
      else
        render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      if current_user.update(name: params[:user][:name])
        render json: {
          status: { code: 200, message: "Name updated successfully." },
          data: UserSerializer.new(current_user).serializable_hash[:data][:attributes]
        }
      else
        render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  private
  def respond_with(current_user, _opts = {})
    if resource.persisted?
      render json: {
        status: { code: 200, message: "Signed up successfully." },
        data: UserSerializer.new(current_user).serializable_hash[:data][:attributes]
      }
    else
      render json: {
        errors: current_user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end
end
