module Api
  module V1
    class ProposalsController < Api::BaseController
      before_action :authenticate, only: [:show, :index, :accept, :reject]
      load_and_authorize_resource :proposal, parent: false, only: [:accept, :reject]
      before_action :load_proposal, only: [:show, :accept, :reject]
      before_action :validate_limit, :validate_offset, only: :index
      before_action only: :index do
        load_limit(Proposal)
        validate_status(CP.statuses)
      end
      has_scope :status, :offset, :limit

      include ApipieDocs::Api::V1::ProposalDoc
      include Validators::FilterValidator

      def show
        respond_with build_data_object(@proposal)
      end

      def index
        respond_with build_data_object(apply_scopes(Proposal))
      end

      def create
        proposal = Proposal.new(proposal_params)
        proposal.pending
        if proposal.save
          render json: build_data_object(proposal), status: 201
        else
          render json: build_error_object(proposal), status: 422
        end
      end

      def accept
        if @proposal.accept
          send_invitation_email(@proposal.email, @proposal.auth_token)
          render json: build_data_object(@proposal), status: 200
        else
          render json: build_error_object(@proposal), status: 422
        end
      end

      def reject
        if @proposal.reject
          send_rejection_email(@proposal.email)
          render json: build_data_object(@proposal), status: 200
        else
          render json: build_error_object(@proposal), status: 422
        end
      end

      private

      def proposal_params
        params.permit(:email, :description)
      end

      def load_proposal
        @proposal = Proposal.find(params[:id])
      end

      def send_invitation_email(email, auth_token)
        InvitationsMailer.send_invitation(email, auth_token).deliver_later
      end

      def send_rejection_email(email)
        # TODO: send rejection email with reason
      end
    end
  end
end
