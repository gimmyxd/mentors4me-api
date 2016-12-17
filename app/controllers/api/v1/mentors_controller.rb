module Api
  module V1
    class MentorsController < UsersController
      before_action :authenticate_invitation, only: :create
      before_action :authenticate, only: :update
      before_action :set_user, only: [:show, :update, :destroy, :password]
      respond_to :json

      def_param_group :user do
        param :first_name, String, desc: 'First Name', required: true
        param :last_name, String, desc: 'Last Name', required: true
        param :phone_number, String, desc: 'Must be a valid phone number', required: true
        param :city, String, desc: 'City of the mentor', required: true
        param :description, String, desc: 'Mentor description', required: true
        param :password, String, desc: 'Password for login', required: true
        param :password_confirmation, String, desc: 'Password confirmation', required: true
        error 401, 'Unauthorized'
        error 422, 'Validation error'
      end

      api :GET, '/mentors', 'Retrevie a list of mentors'
      def index
        respond_with build_data_object(User.includes(:profile).where(role: User::MENTOR))
      end

      api :GET, '/mentors/:id', 'Retrevie a specific mentor'
      error 404, 'Not Found'
      def show
        super
      end

      api :POST, '/mentors/propose', 'Propose a mentor'
      param :email, String, desc: 'Mentor email', required: true
      param :description, String, desc: 'Mentor description', required: true
      error 422, 'Validation error'
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

      api :POST, '/mentors', 'Create a mentor'
      param_group :user
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

      api :PUT, '/mentors/:id', 'Update a specific mentor'
      param_group :user
      error 404, 'Not Found'
      def update
        @user.profile.update(profile_params)
        if @user.update(update_user_params)
          render json: build_data_object(@user), status: 200
        else
          render json: build_error_object(@user), status: 422
        end
      end

      api :DELETE, '/mentors/:id', 'Deletes a specific mentor'
      error 401, 'Unauthorized'
      error 404, 'Not Found'
      def destroy
        super
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
