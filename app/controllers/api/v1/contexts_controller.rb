module Api
  module V1
    class ContextsController < Api::BaseController
      load_and_authorize_resource :context, parent: false
      before_action :authenticate
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
        respond_with build_data_object(apply_scopes(Context))
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
        validate_context
        context = Context.new(context_params)
        context.pending
        if context.save
          render json: build_data_object(context), status: 200
        else
          render json: build_error_object(context), status: 422
        end
      end

      private

      def load_context
        @context = Context.find(params[:id])
      end

      def context_params
        params.permit(:mentor_id, :organization_id, :description)
      end

      def validate_context
        Mentor.find_by!(user_id: params[:mentor_id])
        Organization.find_by(user_id: params[:organization_id])
        raise InvalidAPIRequest.new('context_already_exists', 422) if Context.where(
          mentor_id: params[:mentor_id],
          organization_id: params[:organization_id]
        ).any?
      end
    end
  end
end
