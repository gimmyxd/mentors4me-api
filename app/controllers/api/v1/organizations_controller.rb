module Api
  module V1
    class OrganizationsController < UsersController
      before_action :set_user, only: [:show, :update, :destroy, :password]
      before_action :authenticate, only: :update
      respond_to :json

      include ApipieDocs::Api::V1::OrganizationDoc

      resource_description do
        name 'Organizations'
      end

      def index
        respond_with build_data_object(
          User.includes(:profile)
          .includes(:roles)
          .where(roles: { slug: CR::ORGANIZATION })
        )
      end

      def create
        user = User.new(create_user_params)
        user.assign_roles(Role.organization.id)
        user.active = true
        user.organization = Organization.new(organization_params)
        if user.save
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
