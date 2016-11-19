module Api
  module V1
    class SessionsController < Api::BaseController
      respond_to :json

      def create
        user_password = params[:password]
        user_email = params[:email]
        user = User.find_by(email: user_email) if user_email.present?
        if user.present? && user.valid_password?(user_password) && user.active?
          sign_in user
          user.generate_authentication_token!
          user.save(validate: false)
          render json: { success: true, data: user.as_json(only: :auth_token) }, status: 200
        else
          raise InvalidAPIRequest.new('Invalid username or password', 401)
        end
      end

      def destroy
        user = User.find_by(auth_token: params[:id])
        if user.present?
          user.generate_authentication_token!
          user.save
          head 204
        else
          raise InvalidAPIRequest.new('User not found', 401)
        end
      end

      def sign_in(resource)
        Devise::Mapping.find_scope!(resource)
      end
    end
  end
end
