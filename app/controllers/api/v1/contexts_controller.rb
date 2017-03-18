# frozen_string_literal: true
module Api
  module V1
    class ContextsController < Api::BaseController
      before_action :authenticate
      load_and_authorize_resource :context, parent: false
      before_action :load_context, only: [:show, :update, :destroy, :accept]
      before_action :validate_limit, :validate_mentor_id,
                    :validate_organization_id, :validate_offset, only: :index
      before_action only: :index do
        load_limit(Context)
        validate_date(:start_date)
        validate_date(:end_date)
        validate_status(CC.statuses)
      end
      has_scope :mentor_id, :organization_id, :start_date, :end_date, :status, :offset, :limit
      has_scope :date_interval, using: [:start_date, :end_date], type: :hash

      include ApipieDocs::Api::V1::ContextDoc
      include Validators::FilterValidator

      def show
        respond_with build_data_object(@context)
      end

      def index
        respond_with build_data_object(apply_scopes(current_user.contexts))
      end

      def accept
        @context.accept
        render json: build_data_object(@context), status: 200
      end

      def reject
        @context.reject
        render json: build_data_object(@context), status: 200
      end

      def create
        context = Context.new(context_params)
        context.pending
        if context.save
          send_context_confirmation(context)
          render json: build_data_object(context), status: 200
        else
          render json: build_error_object(context), status: 422
        end
      end

      private

      def send_context_confirmation(context)
        mentor = context.mentor.mentor
        organization = context.organization.organization
        MentorsMailer.send_context_confirmation(
          context.mentor.email,
          name: mentor.first_name,
          organization_name: organization.name,
          context_description: context.description,
          organization_adress: organization.city,
          organization_description: organization.description
        ).deliver_later
      end

      def load_context
        @context = Context.find(params[:id])
      end

      def context_params
        params.permit(:mentor_id, :organization_id, :description)
      end
    end
  end
end
