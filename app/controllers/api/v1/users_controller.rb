module Api
  module V1
    class UsersController < Api::BaseController
      before_action :set_user, only: [:show, :update, :destroy, :password]

      respond_to :json
      # load_and_authorize_resource except: [:create_mentor, :create]

      def show
        respond_with build_data_object(@user)
      end

      def index
        respond_with build_data_object(User.includes(:profile).includes(:organization))
      end

      def me
        respond_with build_data_object(current_user)
      end

      private

      def set_user
        @user = User.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        raise InvalidAPIRequest.new(I18n.t('User not found', id: params[:id]), 404)
      end

      def create_user_params
        params.permit(:email, :password, :password_confirmation)
      end

      def password_params
        params.permit(:current_password, :password, :password_confirmation)
      end

      def update_user_params
        params.permit(:email, :role)
      end
    end
  end
end
