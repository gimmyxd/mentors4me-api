module Api
  module V1
    class ProposalsController < Api::BaseController
      before_action :authenticate, only: [:show, :index, :accept, :reject]
      before_action :load_proposal, only: [:show, :accept, :reject]
      authorize_resource class: false, only: [:accept, :reject]
      respond_to :json
      before_action :load_limit, :validate_limit, :validate_offset, only: :index
      has_scope :status, :offset, :limit

      include ApipieDocs::Api::V1::ProposalDoc

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
          send_invitation_email(@proposal.email, @proposal.invitation_token)
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

      def send_invitation_email(email, invitation_token)
        InvitationsMailer.send_invitation(email, invitation_token).deliver_later
      end

      def send_rejection_email(email)
        # TODO: send rejection email with reason
      end

      def validate_status
        return unless params[:status].present?
        return if CP.statuses.include? params[:status]
        raise InvalidAPIRequest.new('status.not_in_list', 422)
      end

      def validate_numericality(field, error_message)
        Integer(field) if field.present?
      rescue ArgumentError
        raise InvalidAPIRequest.new(error_message, 422)
      end

      def validate_limit
        validate_numericality(params[:limit], 'limit.not_a_number')
      end

      def validate_offset
        validate_numericality(params[:offset], 'offset.not_a_number')
      end

      def load_limit
        params[:limit] = Proposal.count if params[:limit].blank?
      end
    end
  end
end
