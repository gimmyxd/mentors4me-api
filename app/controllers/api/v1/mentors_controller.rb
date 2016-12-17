module Api
  module V1
    class MentorsController < UsersController
      before_action :authenticate_invitation, only: :create
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

      def propose
        if exsisting_user?
          render json: { errors: 'User already exists' }, status: 422
          return
        end
        proposal = Proposal.new(proposal_params)
        if proposal.save
          generate_user(proposal)
          render json: { success: true }, status: 201
        else
          render json: build_error_object(proposal), status: 422
        end
      end

      def create
        user = User.find_by(invitation_token: request.headers['Authorization'])
        return unless user
        user.profile = Profile.new(profile_params)
        user.profile.skills = assign_skills(params[:skill_ids])
        if user.update(create_user_params)
          user.update_attributes(invitation_token: nil, active: true)
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

      def exsisting_user?
        User.find_by(email: params[:email]).present? || Proposal.find_by(email: params[:email]).present?
      end

      def generate_user(proposal)
        user = User.new(email: params[:email], role: User::MENTOR, active: false)
        user.generate_invitation_token!
        proposal.pending
        user.proposal = proposal
        user.save(validate: false)
      end

      def assign_skills(skill_ids)
        raise InvalidAPIRequest.new('skill_ids must be string', 401) unless skill_ids.is_a? String
        raise InvalidAPIRequest.new('Skill is needed', 401) if skill_ids.blank?
        skills = Skill.where(id: skill_ids.split(',').map(&:to_i))
        raise InvalidAPIRequest.new('Skill is needed', 401) unless skills.any?
        skills
      end

      def proposal_params
        params.permit(:email, :description)
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
