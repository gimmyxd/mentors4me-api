module Api
  module V1
    class UsersController < Api::BaseController
      before_action :authenticate, except: :create_mentor
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
        profile = Profile.new(profile_params)
        if profile.save
          user.profile = profile
          if user.update(create_user_params)
            user.invitation_token = nil
            render json: build_data_object(user), status: 200
          else
            render json: build_error_object(user), status: 422
          end
        else
          render json: build_error_object(profile), status: 422
        end
      end

      def create
        create_user_params[:role] = User::NORMAL
        user = User.new(create_user_params)
        organization = Organization.new(organization_params)
        user.generate_authentication_token!
        if organization.save
          user.organization = organization
          if user.update(create_user_params)
            render json: build_data_object(user), status: 200
          else
            render json: build_error_object(user), status: 422
          end
        else
          render json: build_error_object(organization), status: 422
        end
      end

      private

      def set_user
        @user = User.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        raise InvalidAPIRequest.new(I18n.t('User not found', id: params[:id]), 404)
      end

      def profile_params
        params.permit(
          :first_name, :last_name, :email,
          :phone_number, :city, :description
        )
      end

      def create_user_params
        params.permit(:email, :password, :password_confirmation)
      end

      def organization_params
        params.permit(
          :name, :asignee, :email, :phone_number,
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
