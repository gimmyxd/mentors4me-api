module Api
  module V1
    class MentorsController < UsersController
      before_action :authenticate_invitation, only: :create
      before_action :set_user, only: [:show, :update, :destroy, :password]

      respond_to :json

      def create
        user = User.find_by(invitation_token: request.headers['Authorization'])
        return unless user
        user.profile = Profile.new(profile_params)
        user.active = true
        user.invitation_token = nil
        if user.update(create_user_params)
          render json: build_data_object(user), status: 200
        else
          render json: build_error_object(user), status: 422
        end
      end

      def update
        @user.profile.update(profile_params)
        if @user.update(update_user_params)
          render json: build_data_object(@user), status: 200
        else
          render json: build_error_object(@user), status: 422
        end
      end

      private

      def profile_params
        params.require(:profile).permit(
          :first_name, :last_name,
          :phone_number, :city, :description
        )
      end
    end
  end
end
