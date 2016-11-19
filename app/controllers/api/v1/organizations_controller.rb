module Api
  module V1
    class OrganizationsController < UsersController
      before_action :set_user, only: [:show, :update, :destroy, :password]

      respond_to :json
      # load_and_authorize_resource except: [:create_mentor, :create]

      def create
        user = User.new(create_user_params)
        user.role = User::NORMAL
        user.active = true
        user.organization = Organization.new(organization_params)
        if user.update(create_user_params)
          render json: build_data_object(user), status: 200
        else
          render json: build_error_object(user), status: 422
        end
      end

      def update
        @user.organization.update(organization_params)
        if @user.update(update_user_params)
          render json: build_data_object(@user), status: 200
        else
          render json: build_error_object(@user), status: 422
        end
      end

      private

      def organization_params
        params.permit(
          :name, :asignee, :phone_number,
          :city, :description
        )
      end
    end
  end
end
