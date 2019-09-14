# frozen_string_literal: true

module Api
  module V1
    class OrganizationsController < UsersController
      before_action only: %i[show update destroy password] do
        load_user(CR::ORGANIZATION)
      end

      def show
        respond_with build_data_object(@user)
      end

      def index
        respond_with build_data_object(
          apply_scopes(
            User.includes(:organization)
              .includes(:mentor)
              .includes(:role_assignments)
              .includes(:roles)
              .organization
          )
        )
      end

      def create
        user = User.new(create_user_params)
        user.assign_roles(Role.organization.id)
        user.active = true
        user.organization = Organization.new(organization_params)
        if user.save
          OrganizationsMailer.send_confirmation(
            user.email, user.organization.asignee
          )
          render json: build_data_object(user), status: 201
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
          :city, :description, :facebook
        )
      end
    end
  end
end
