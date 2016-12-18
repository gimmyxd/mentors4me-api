module ApipieDocs
  module Api
    module V1
      module ContextDoc
        extend BaseResource

        def self.superclass
          Api::V1::ContextsController
        end

        doc_for :show do
          api :GET, '/contexts/:id', 'Retrevie a specific context'
          error 401, 'Unauthorized'
          error 404, 'Not Found'
        end

        doc_for :index do
          api :GET, '/contexts', 'Retrevie a list of contexts'
          param :filter, %w(profile_id organization start_date end_date status limit offset),
                'The filtering query:
                - url example for filtering by organization_id:
                    .../api/contexts?organization_id=1
              '
          error 401, 'Unauthorized'
        end

        doc_for :create do
          api :POST, '/contexts', 'Organization creates a context with the mentor'
          param :profile_id, Integer, desc: 'The profile of the mentor to be invited by current organization', required: true
          param :organization_id, Integer, desc: 'The id of current organization', required: true
          param :description, String, desc: 'A description for the request', required: true
          error 401, 'Unauthorized'
          error 422, 'Validation error'
        end

        doc_for :accept do
          api :POST, '/contexts/:id/accept', 'Mentor accepts the invitation for an organization'
          error 401, 'Unauthorized'
          error 404, 'Not Found'
        end

        doc_for :reject do
          api :POST, '/contexts/:id/reject', 'Mentor rejects the invitation for an organization'
          error 401, 'Unauthorized'
          error 404, 'Not Found'
        end
      end
    end
  end
end
