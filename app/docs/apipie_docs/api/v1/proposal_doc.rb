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

                status = [accepted, pending, rejected]
              '
          error 401, 'Unauthorized'
          error 422, 'Validation error'
        end

        doc_for :create do
          api :POST, '/proposals', 'Propose a nemntor'

          param :proposer_first_name, String, desc: 'Proposer\'s first name', required: true
          param :proposer_last_name, String,  desc: 'Proposer\'s last name', required: true
          param :proposer_email, String, desc: 'Proposer\'s email', required: true
          param :proposer_phone_number, String, desc: 'Proposer\'s phone number', required: true
          param :mentor_first_name, String, desc: 'Mentor\'s first name', required: true
          param :mentor_last_name, String, desc: 'Mentor\'s last name', required: true
          param :mentor_organization, String, desc: 'Mentor\'s organization', required: true
          param :mentor_email, String, desc: 'Mentor\'s email', required: true
          param :mentor_phone_number, String, desc: 'Mentor\'s phone number', required: true
          param :mentor_facebook, String, desc: 'Mentor\'s facebook', required: false
          param :mentor_linkedin, String, desc: 'Mentor\'s linkedin', required: false
          param :reason, String, desc: 'The reason for proposing this mentor', required: true
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
