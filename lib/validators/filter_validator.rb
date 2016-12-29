module Validators
  module FilterValidator
    private

    def validate_numericality(field, error_message)
      Integer(field) if field.present?
    rescue ArgumentError
      raise Api::BaseController::InvalidAPIRequest.new(error_message, 422)
    end

    def valid_date?(date, format = '%Y-%m-%d')
      date = Date.parse(date).to_s
      DateTime.strptime(date, format)
      raise ArgumentError unless /^\d{4}-\d{2}-\d{2}$/ =~ date
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

    def load_limit(resource)
      params[:limit] = resource.count if params[:limit].blank?
    end

    def validate_status(list)
      return unless params[:status].present?
      return if list.include? params[:status]
      raise Api::BaseController::InvalidAPIRequest.new('status.not_in_list', 422)
    end

    def validate_date(margin)
      return unless params[margin]
      valid_date?(params[margin])
    rescue ArgumentError
      raise Api::BaseController::InvalidAPIRequest.new("#{margin}.invalid_fromat", 422)
    end
  end
end
