# frozen_string_literal: true

module Api
  module V1
    class SessionsController < Api::BaseController
      def create
        user = User.find_by(email: params[:email])
        raise InvalidAPIRequest.new('session.invalid', 401) unless valid_sign_in?(user)

        user.generate_authentication_token!
        user.save
        render json: { success: true, data: user.as_json(only: :auth_token) }, status: 200
      end

      def destroy
        user = User.find_by!(auth_token: params[:id])
        user.generate_authentication_token!
        user.save
        head 204
      end

      def valid_sign_in?(user)
        user.present? && user.valid_password?(params[:password]) && user.active?
      end
    end
  end
end
