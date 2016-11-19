module Api
  module V1
    class InvitationsController < Api::BaseController
      before_action :authenticate
      respond_to :json
      authorize_resource class: false

      def create
        authorize! :create, current_user
        user = User.find_by!(email: params[:email])
      rescue ActiveRecord::RecordNotFound
        raise InvalidAPIRequest.new('User not found', 404)
      else
        if user.proposal.present? && user.proposal.pending?
          user.proposal.accept
          send_invitation(params[:email], user.invitation_token)
          render json: { success: true }, status: 200
        else
          raise InvalidAPIRequest.new('Only proposed users can be invited', 422)
        end
      end

      def reject
        authorize! :reject, current_user
        user = User.find_by!(email: params[:email])
        proposal = Proposal.find_by!(email: params[:email])
      rescue ActiveRecord::RecordNotFound
        raise InvalidAPIRequest.new('Email not found', 404)
      else
        if user.proposal.pending?
          user.destroy
          proposal.reject
          render json: { success: true }, status: 200
        else
          raise InvalidAPIRequest.new('Only pending proposals can be rejected', 422)
        end
      end

      private

      def send_invitation(email, invitation_token)
        InvitationsMailer.send_invitation(email, invitation_token).deliver_later
      end

      def invitation_params
        params.permit(:email)
      end
    end
  end
end
