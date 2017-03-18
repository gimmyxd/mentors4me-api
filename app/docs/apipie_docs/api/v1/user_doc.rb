# frozen_string_literal: true
module ApipieDocs
  module Api
    module V1
      module UserDoc
        extend BaseResource

        def self.superclass
          Api::V1::UsersController
        end

        doc_for :index do
          api :GET, '/users', 'Retrevie a list of users'
          param :filter, %w(limit offset status),
                'The filtering query:
                - url example for by status:
                    .../api/users?status=active

                    status = [active, inactive]
              '
          error 401, 'Unauthorized'
        end

        doc_for :show do
          api :GET, '/users/:id', 'Retrevie a specific user'
          error 401, 'Unauthorized'
          error 404, 'Not Found'
        end

        doc_for :me do
          api :GET, '/users/me', 'Retrevie current user based on authorization token'
          error 404, 'Not Found'
        end

        doc_for :password do
          api :POST, '/users/:id/password', 'Change the user password'
          param :current_password, String, desc: 'Current  password', required: true
          param :password, String, desc: 'New password', required: true
          param :password_confirmation, String, desc: 'New password', required: true
          error 401, 'Unauthorized'
          error 404, 'Not Found'
          error 422, 'Validation Error'
        end

        doc_for :activate do
          api :PUT, '/users/:id/activate', 'Activates a specific user'
          error 401, 'Unauthorized'
          error 403, 'Forbidden'
          error 404, 'Not Found'
        end

        doc_for :deactivate do
          api :PUT, '/users/:id/deactivate', 'Deactivates a specific user'
          error 401, 'Unauthorized'
          error 403, 'Forbidden'
          error 404, 'Not Found'
        end
      end
    end
  end
end
