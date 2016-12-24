module Api
  module V1
    class UsersController < Api::BaseController
      before_action :authenticate
      before_action :set_user, only: [:show, :update, :destroy, :password]
      load_and_authorize_resource :user, parent: false, only: :update
      respond_to :json

      include ApipieDocs::Api::V1::UserDoc

      resource_description do
        name 'Users'
        description <<-EOS
             General endpoint for managing all types of users.
          EOS
      end

      def show
        respond_with build_data_object(@user)
      end

      def index
        respond_with build_data_object(
          User.includes(:profile)
            .includes(:organization)
            .includes(:roles)
        )
      end

      def me
        raise InvalidAPIRequest.new('Invalid token', 404) unless current_user
        respond_with build_data_object(current_user)
      end

      def password
        if @user.update_with_password(password_params)
          render json: build_data_object(@user), status: 200
        else
          render json: build_error_object(@user), status: 422
        end
      end

      private

      def set_user
        @user = User.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        raise InvalidAPIRequest.new(I18n.t('User not found', id: params[:id]), 404)
      end

      def create_user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end

      def password_params
        params.require(:user).permit(:current_password, :password, :password_confirmation)
      end

      def update_user_params
        params.require(:user).permit(:email, :role, :password, :password_confirmation)
      end
    end
  end
end
