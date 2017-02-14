module Api
  module V1
    class ContactsController < ApplicationController
      include ApipieDocs::Api::V1::ContactDoc

      def create
        ContactMailer.send_notification(ENV['CONTACT_EMAIL'], contact_params.to_h).deliver_later
        render json: { success: true }, status: 200
      end

      private

      def contact_params
        params.permit(:first_name, :last_name, :email, :message)
      end
    end
  end
end
