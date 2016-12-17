module Api
  module V1
    class MentorsController < UsersController
      before_action :validate_request, only: :create
      before_action :authenticate, only: :update
      before_action :set_user, only: [:show, :update, :destroy, :password]
      respond_to :json

      include ApipieDocs::Api::V1::MentorDoc

      resource_description do
        name 'Mentors'
      end

      def index
        respond_with build_data_object(User.includes(:profile).where(role: User::MENTOR))
      end

      def show
        respond_with build_data_object(@user)
      end

      def create
        user = User.new(create_user_params)
        user.role = User::MENTOR
        user.active  = true
        user.profile = Profile.new(profile_params)
        user.profile.skills = assign_skills(params[:skill_ids])
        if user.save
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

      def validate_request
        token = request.headers['Authorization']
        return if token.present? && Proposal.where(invitation_token: token).any?
        raise InvalidAPIRequest.new('Invalid invitation token', 401)
      end

      def assign_skills(skill_ids)
        raise InvalidAPIRequest.new('skill_ids must be string', 401) unless skill_ids.is_a? String
        raise InvalidAPIRequest.new('Skill is needed', 401) if skill_ids.blank?
        skills = Skill.where(id: skill_ids.split(',').map(&:to_i))
        raise InvalidAPIRequest.new('Skill is needed', 401) unless skills.any?
        skills
      end

      def profile_params
        params.permit(
          :first_name, :last_name, :phone_number,
          :city, :description
        )
      end
    end
  end
end
