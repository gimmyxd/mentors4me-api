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

      def accept
        user = User.find(@proposal.id)
      rescue ActiveRecord::RecordNotFound
        raise InvalidAPIRequest.new('no user associated for this proposal', 404)
      else
        @proposal.accept
        send_invitation_email(user.email, user.invitation_token)
        render json: { success: true }, status: 200
      end

      def reject
        user = User.find(@proposal.id)
      rescue ActiveRecord::RecordNotFound
        raise InvalidAPIRequest.new('no user associated for this proposal', 404)
      else
        @proposal.reject
        send_rejection_email(user.email)
        render json: { success: true }, status: 200
      end

      private

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
