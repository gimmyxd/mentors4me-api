module ApipieDocs
  module Api
    module V1
      module MentorDoc
        extend BaseResource

        def self.superclass
          Api::V1::MentorsController
        end

        def_param_group :user do
          param :first_name, String, desc: 'First Name', required: true, action_aware: true
          param :last_name, String, desc: 'Last Name', required: true, action_aware: true
          param :phone_number, String, desc: 'Must be a valid phone number', required: true, action_aware: true
          param :city, String, desc: 'City of the mentor', required: true, action_aware: true
          param :description, String, desc: 'Mentor description', required: true, action_aware: true
          param :password, String, desc: 'Password for login', required: true, action_aware: true
          param :password_confirmation, String, desc: 'Password confirmation', required: true, action_aware: true
          error 401, 'Unauthorized'
          error 422, 'Validation error'
        end

        doc_for :index do
          api :GET, '/mentors', 'Retrevie a list of mentors'
        end

        doc_for :show do
          api :GET, '/mentors/:id', 'Retrevie a specific mentor'
          error 404, 'Not Found'
        end

        doc_for :propose do
          api :POST, '/mentors/propose', 'Propose a mentor'
          param :email, String, desc: 'Mentor email', required: true
          param :description, String, desc: 'Mentor description', required: true
          error 422, 'Validation error'
        end

        doc_for :create do
          api :POST, '/mentors', 'Create a mentor'
          param_group :user, as: :create
        end

        doc_for :update do
          api :PUT, '/mentors/:id', 'Update a specific mentor'
          param_group :user, as: :update
          error 404, 'Not Found'
        end

        doc_for :destroy do
          api :DELETE, '/mentors/:id', 'Deletes a specific mentor'
          error 401, 'Unauthorized'
          error 404, 'Not Found'
        end
      end
    end
  end
end
