module Api
  module V1
    class InvitationsController < Api::BaseController
      respond_to :json

      def create
        user = generate_user
        if user.save
          send_invitation(invitation_params[:email])
          render json: { success: user.invitation_token }, status: 201
        else
          render json: build_error_object(user), status: 422
        end
      end

      private

      def generate_user
        user = User.new(email: invitation_params[:email], role: User::MENTOR)
        user.generate_invitation_token!
        user.password = Devise.friendly_token.first(8)
        user
      end

      def send_invitation(email)
        InvitationsMailer.send_invitation(email).deliver
      end

      def invitation_params
        params.permit(:email)
      end
    end
  end
end
