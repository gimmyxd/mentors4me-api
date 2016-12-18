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
      end
    end
  end
end
