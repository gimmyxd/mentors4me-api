module Api
  module V1
    class UsersController < Api::BaseController
      before_action :authenticate, except: [:create_mentor, :create]
      before_action :authenticate_invitation, only: :create_mentor
      before_action :set_user, only: [:show, :update, :destroy, :password]

      respond_to :json
      # load_and_authorize_resource except: [:create_mentor, :create]

      def show
        respond_with build_data_object(@user)
      end

      def index
        respond_with build_data_object(User.includes(:profile))
      end

      def me
        respond_with build_data_object(current_user)
      end

      def create_mentor
        user = User.find_by(invitation_token: request.headers['Authorization'])
        return unless user
        user.profile = Profile.new(profile_params)
        if user.update(create_user_params)
          activate_user!(user)
          render json: build_data_object(user), status: 200
        else
          render json: build_error_object(user), status: 422
        end
      end

      def create
        create_user_params[:role] = User::NORMAL
        create_user_params[:active] = true
        user = User.new(create_user_params)
        user.organization = Organization.new(organization_params)
        if user.update(create_user_params)
          normal_user!(user)
          render json: build_data_object(user), status: 200
        else
          render json: build_error_object(user), status: 422
        end
      end

      private

      def set_user
        @user = User.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        raise InvalidAPIRequest.new(I18n.t('User not found', id: params[:id]), 404)
      end

      def activate_user!(user)
        user.active = true
        user.invitation_token = nil
        user.save!
      end

      def normal_user!(user)
        user.active = true
        user.role = User::NORMAL
        user.save!
      end

      def profile_params
        params.require(:profile).permit(
          :first_name, :last_name,
          :phone_number, :city, :description
        )
      end

      def create_user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end

      def organization_params
        params.permit(
          :name, :asignee, :phone_number,
          :city, :description
        )
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
