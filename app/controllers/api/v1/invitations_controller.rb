module Api
  module V1
    class InvitationsController < Api::BaseController
      respond_to :json

      def create
        user = User.find_by!(email: params[:email])
      rescue ActiveRecord::RecordNotFound
        render json: { 'errors': 'User not found' }, status: 404
      else
        if user.proposal.present? && user.proposal.pending?
          user.proposal.accept
          send_invitation(params[:email], user.invitation_token)
          render json: { success: user.invitation_token }, status: 200
        else
          render json: { errors: 'Only proposed users can be invited' }, status: 200
        end
      end

      def reject
        user = User.find_by!(email: params[:email])
        proposal = Proposal.find_by!(email: params[:email])
      rescue ActiveRecord::RecordNotFound
        render json: { 'errors': 'Email not found' }, status: 404
      else
        if user.proposal.pending?
          user.destroy
          proposal.reject
          render json: { success: true }, status: 200
        else
          render json: { errors: 'Only pending proposals can be rejected' }, status: 422
        end
      end

      private

      def send_invitation(email, invitation_token)
        InvitationsMailer.send_invitation(email, invitation_token).deliver
      end

      def invitation_params
        params.permit(:email)
      end
    end
  end
end
