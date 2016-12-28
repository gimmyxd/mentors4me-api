module Api
  module V1
    class UsersController < Api::BaseController
      before_action :authenticate
      before_action only: [:show, :update, :destroy, :password] do
        load_user(CR.roles)
      end
      load_and_authorize_resource :user, parent: false, only: :update
      respond_to :json

      include ApipieDocs::Api::V1::UserDoc

      def show
        respond_with build_data_object(@user)
      end

      def index
        respond_with build_data_object(
          User.includes(mentor: :skills)
            .includes(:organization)
            .includes(:roles)
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

      private

      def load_user(roles)
        @user = User.includes(:roles).find_by!(id: params[:id], roles: { slug: Array(roles) })
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
