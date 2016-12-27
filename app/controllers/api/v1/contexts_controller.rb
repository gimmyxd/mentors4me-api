module Api
  module V1
    class ContextsController < Api::BaseController
      before_action :authenticate
      before_action :load_context, only: [:show, :update, :destroy, :accept]
      before_action :load_limit, :validate_limit, :validate_mentor_id,
                    :validate_start_date, :validate_end_date, :validate_status,
                    :validate_organization_id, :validate_offset, only: :index
      has_scope :mentor_id, :organization_id, :start_date, :end_date, :status, :offset, :limit
      has_scope :date_interval, using: [:start_date, :end_date], type: :hash
      load_and_authorize_resource :context, parent: false
      respond_to :json

      include ApipieDocs::Api::V1::ContextDoc

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

      def validate_numericality(field, error_message)
        Integer(field) if field.present?
      rescue ArgumentError
        raise InvalidAPIRequest.new(error_message, 422)
      end

      def validate_mentor_id
        validate_numericality(params[:mentor_id], 'mentor_id.not_a_number')
      end

      def validate_organization_id
        validate_numericality(params[:organization_id], 'organization_id.not_a_number')
      end

      def validate_limit
        validate_numericality(params[:limit], 'limit.not_a_number')
      end

      def validate_offset
        validate_numericality(params[:offset], 'offset.not_a_number')
      end

      def load_limit
        params[:limit] = Context.count if params[:limit].blank?
      end

      def validate_status
        return unless params[:status].present?
        return if CC.statuses.include? params[:status]
        raise InvalidAPIRequest.new('status.not_in_list', 422)
      end

      def validate_start_date
        return unless params[:start_date]
        valid_date?(params[:start_date])
      rescue ArgumentError
        raise InvalidAPIRequest.new('start_date.invalid_fromat', 422)
      end

      def validate_end_date
        return unless params[:end_date]
        valid_date?(params[:end_date])
      rescue ArgumentError
        raise InvalidAPIRequest.new('end_date.invalid_fromat', 422)
      end
    end
  end
end
