# frozen_string_literal: true

module Api
  module V1
    class UsersController < Api::BaseController
      before_action :authenticate
      load_and_authorize_resource :user, parent: false, only: %i[update password destroy activate deactivate]
      before_action only: %i[show update destroy password activate deactivate] do
        load_user(CR.roles)
      end
      before_action only: :index do
        validate_limit
        validate_offset
        validate_status(%w[active inactive])
      end

      has_scope :offset, :limit, :status

      include Validators::FilterValidator

      def show
        respond_with build_data_object(@user)
      end

      def index
        respond_with build_data_object(
          apply_scopes(User.includes(mentor: :skills).includes(:organization).includes(:roles))
        )
      end

      def me
        raise InvalidAPIRequest.new('unauthorized', 401) unless current_user

        respond_with build_data_object(current_user)
      end

      def password
        if @user.update_with_password(password_params)
          render json: build_data_object(@user), status: 200
        else
          render json: build_error_object(@user), status: 422
        end
      end

      def deactivate
        @user.active = false
        @user.generate_authentication_token!
        if @user.save
          render json: { success: true }, status: 200
        else
          render json: build_error_object(@user), status: 422
        end
      end

      def activate
        @user.active = true
        if @user.save
          render json: { success: true }, status: 200
        else
          render json: build_error_object(@user), status: 422
        end
      end

      private

      def load_user(roles)
        @user = User.includes(:roles).find_by!(id: params[:id], roles: { slug: Array(roles) })
        return if current_user.present? && current_user.admin?
        raise ActiveRecord::RecordNotFound unless @user.active?
      end

      def create_user_params
        params.permit(:email, :password, :password_confirmation)
      end

      def update_user_params
        params.permit(:email)
      end

      def password_params
        params.permit(:current_password, :password, :password_confirmation)
      end
    end
  end
end
