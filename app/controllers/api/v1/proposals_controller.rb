# frozen_string_literal: true

module Api
  module V1
    class ProposalsController < Api::BaseController
      before_action :authenticate, only: %i[show index accept reject]
      load_and_authorize_resource :proposal, parent: false, only: %i[accept reject]
      before_action :load_proposal, only: %i[show accept reject]
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
          notify_proposer(proposal_params[:proposer_email], proposal_params[:proposer_first_name])
          render json: build_data_object(proposal), status: 201
        else
          render json: build_error_object(proposal), status: 422
        end
      end

      def accept
        if @proposal.accept
          send_invitation_email(@proposal.mentor_email, @proposal.auth_token)
          render json: build_data_object(@proposal), status: 200
        else
          render json: build_error_object(@proposal), status: 422
        end
      end

      def reject
        if @proposal.reject
          send_rejection_email(@proposal.mentor_email)
          render json: build_data_object(@proposal), status: 200
        else
          render json: build_error_object(@proposal), status: 422
        end
      end

      private

      def proposal_params
        params.permit(
          :proposer_first_name, :proposer_last_name, :proposer_email, :proposer_phone_number,
          :mentor_first_name, :mentor_last_name, :mentor_organization, :mentor_email, :mentor_phone_number,
          :mentor_facebook, :mentor_linkedin, :reason
        )
      end

      def load_proposal
        @proposal = Proposal.find(params[:id])
      end

      def send_invitation_email(email, auth_token)
        InvitationsMailer.send_invitation(email, auth_token).deliver_later
      end

      def notify_proposer(email, first_name)
        ProposalsMailer.send_confirmation(email, first_name: first_name).deliver_later
      end

      def send_rejection_email(email)
        # TODO: send rejection email with reason
      end
    end
  end
end
