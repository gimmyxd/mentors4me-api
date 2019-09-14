# frozen_string_literal: true

module Api
  module V1
    class ContactsController < ApplicationController
      include ApipieDocs::Api::V1::ContactDoc

      def create
        if errors.any?
          render json: { success: false, errors: errors }, status: 422
        else
          ContactMailer.send_notification(ENV['CONTACT_EMAIL'], contact_params.to_h)
          render json: { success: true }, status: 200
        end
      end

      private

      def required_params
        %w[first_name last_name email message]
      end

      def errors
        errors = []
        required_params.each do |key|
          errors << "#{key}.blank" unless params.include?(key) && params[key].present?
        end
        errors
      end

      def contact_params
        params.permit(:first_name, :last_name, :email, :message)
      end
    end
  end
end
