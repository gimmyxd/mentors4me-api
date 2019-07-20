# frozen_string_literal: true

module ApipieDocs
  module Api
    module V1
      module MentorDoc
        extend BaseResource

        def self.superclass
          Api::V1::MentorsController
        end

        def_param_group :mentor do
          param :email, String, desc: 'Email', required: true, action_aware: true
          param :first_name, String, desc: 'First Name', required: true, action_aware: true
          param :last_name, String, desc: 'Last Name', required: true, action_aware: true
          param :phone_number, String, desc: 'Must be a valid phone number', required: true, action_aware: true
          param :city, String, desc: 'City of the mentor', required: true, action_aware: true
          param :description, String, desc: 'Mentor description', required: true, action_aware: true
          param :organization, String, desc: 'Mentor organization', required: false, action_aware: true
          param :position, String, desc: 'Mentor position in organization', required: false, action_aware: true
          param :occupation, String, desc: 'Mentor occupation/profession', required: false, action_aware: true
          param :availability, Float, desc: 'Mentor available slots(hours)', required: true, action_aware: true
          param :facebook, String, desc: 'Mentor facebook', required: false, action_aware: true
          param :linkedin, String, desc: 'Mentor linkedin', required: false, action_aware: true
          param :skill_ids, String, desc: 'The ids of the mentor skills', required: true, action_aware: true
          param :password, String, desc: 'Password for login', required: true, action_aware: true
          param :password_confirmation, String, desc: 'Password confirmation', required: true, action_aware: true
          error 401, 'Unauthorized'
          error 422, 'Validation error'
        end

        doc_for :index do
          api :GET, '/mentors', 'Retrevie a list of mentors'
          param :filter, %w[limit offset status],
                'The filtering query:
                - url example for by status:
                    .../api/users?status=active

                    status = [active, inactive]
              '
        end

        doc_for :show do
          api :GET, '/mentors/:id', 'Retrevie a specific mentor'
          error 404, 'Not Found'
        end

        doc_for :create do
          api :POST, '/mentors', 'Create a mentor'
          param_group :mentor, as: :create
        end

        doc_for :update do
          api :PUT, '/mentors/:id', 'Update a specific mentor'
          param_group :mentor, as: :update
          error 404, 'Not Found'
        end
      end
    end
  end
end
