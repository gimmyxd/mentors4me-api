module ApipieDocs
  module Api
    module V1
      module ProposalDoc
        extend BaseResource

        def self.superclass
          Api::V1::ProposalsController
        end

        doc_for :show do
          api :GET, '/proposals/:id', 'Retrevie a specific proposal'
          error 401, 'Unauthorized'
          error 404, 'Not Found'
        end

        doc_for :index do
          api :GET, '/proposals', 'Retrevie a list of proposals'
          param :filter, %w(status limit offset),
                'The filtering query:
                - url example for filtering by status:
                    .../api/proposals?status=pending
              '
          error 401, 'Unauthorized'
        end

        doc_for :create do
          api :POST, '/proposals', 'Propose a nemntor'
          param :email, Integer, desc: 'The email of the proposed mentor', required: true
          param :description, String, desc: 'A description for the request', required: true
          error 401, 'Unauthorized'
          error 422, 'Validation error'
        end

        doc_for :accept do
          api :POST, '/proposals/:id/accept', 'Admin accepts the proposal of a mentor'
          error 401, 'Unauthorized'
          error 404, 'Not Found'
        end

        doc_for :reject do
          api :POST, '/proposals/:id/reject', 'Admin rejects the proposal of a mentor'
          error 401, 'Unauthorized'
          error 404, 'Not Found'
        end
      end
    end
  end
end
