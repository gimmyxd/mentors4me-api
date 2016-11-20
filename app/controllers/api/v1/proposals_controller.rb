module Api
  module V1
    class ProposalsController < Api::BaseController
      before_action :authenticate
      before_action :set_proposal, only: [:show, :accept, :reject]
      authorize_resource class: false
      respond_to :json
      before_filter :set_limit, :validate_limit, :validate_offset, only: :index
      has_scope :status, :offset, :limit

      def show
        respond_with build_data_object(@proposal)
      end

      def index
        respond_with build_data_object(apply_scopes(Proposal))
      end

      private

      def set_proposal
        @proposal = Proposal.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        raise InvalidAPIRequest.new('proposal not found', 404)
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
