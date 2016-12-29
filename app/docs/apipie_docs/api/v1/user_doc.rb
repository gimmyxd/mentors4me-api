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
          param :filter, %w(limit offset),
                'The filtering query:
                - url example for filtering by limit and offset:
                    .../api/users?limit=10&offset=2
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
      end
    end
  end
end
