module Api
  module V1
    class ProposalsController < Api::BaseController
      before_action :authenticate
      before_action :set_proposal, only: [:show, :accept, :reject]
      authorize_resource class: false
      respond_to :json
      before_action :set_limit, :validate_limit, :validate_offset, only: :index
      has_scope :status, :offset, :limit

      def show
        respond_with build_data_object(@proposal)
      end

      def index
        respond_with build_data_object(apply_scopes(Proposal))
      end

      def create
        if exsisting_user?
          render json: { errors: 'User already exists' }, status: 422
          return
        end
        proposal = Proposal.new(proposal_params)
        proposal.pending(false)
        if proposal.save
          render json: build_data_object(proposal), status: 201
        else
          render json: build_error_object(proposal), status: 422
        end
      end

      def accept
        raise InvalidAPIRequest.new('only pending proposals can be accepted', 404) unless @proposal.accept
        send_invitation_email(@proposal.email, @proposal.invitation_token)
        render json: build_data_object(@proposal), status: 200
      end

      def reject
        raise InvalidAPIRequest.new('only pending proposals can be rejected', 404) unless @proposal.reject
        send_rejection_email(@proposal.email)
        render json: build_data_object(@proposal), status: 200
      end

      private

      def proposal_params
        params.permit(:email, :description)
      end

      def set_proposal
        @proposal = Proposal.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        raise InvalidAPIRequest.new('proposal not found', 404)
      end

      def send_invitation_email(email, invitation_token)
        InvitationsMailer.send_invitation(email, invitation_token).deliver_later
      end

      def send_rejection_email(email)
        # TODO: send rejection email with reason
      end

      def exsisting_user?
        User.find_by(email: params[:email]).present? || Proposal.find_by(email: params[:email]).present?
      end

      def validate_numericality(field, error_message)
        Integer(field) if field.present?
      rescue ArgumentError
        raise InvalidAPIRequest.new(error_message, 422)
      end

      def validate_limit
        validate_numericality(params[:limit], 'limit must be a number')
      end

      def validate_offset
        validate_numericality(params[:offset], 'offset must be a number')
      end

      def set_limit
        params[:limit] = Proposal.count if params[:limit].blank?
      end
    end
  end
end
