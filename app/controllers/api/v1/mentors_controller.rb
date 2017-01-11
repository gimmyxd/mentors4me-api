module Api
  module V1
    class MentorsController < UsersController
      before_action :authenticate_create, only: :create
      before_action :authenticate, only: :update
      before_action only: [:show, :update, :destroy, :password] do
        load_user(CR::MENTOR)
      end

      include ApipieDocs::Api::V1::MentorDoc

      def index
        respond_with build_data_object(
          apply_scopes(
            User.includes(mentor: :skills)
              .includes(:organization)
              .includes(:role_assignments)
              .includes(:roles)
              .where(roles: { slug: CR::MENTOR })
          )
        )
      end

      def show
        respond_with build_data_object(@user)
      end

      def create
        user = User.new(create_user_params)
        user.assign_roles(Role.mentor.id)
        user.active = true
        user.mentor = Mentor.new(mentor_params)
        user.mentor.assign_skills(params[:skills])
        if user.save
          render json: build_data_object(user), status: 201
        else
          render json: build_error_object(user), status: 422
        end
      end

      def update
        @user.mentor.update(mentor_params)
        @user.mentor.assign_skills(params[:skills])
        if @user.update(update_user_params)
          render json: build_data_object(@user), status: 200
        else
          render json: build_error_object(@user), status: 422
        end
      end

      private

      def mentor_params
        params.permit(
          :first_name, :last_name, :phone_number,
          :city, :description, :facebook, :linkedin
        )
      end
    end
  end
end
