module Api
  class BaseController < ActionController::API
    # minimum required controller functionality for rendering, proper mime-type
    # setting, and rescue_from functionality
    include Authenticable

    MODULES = [
      ActionController::MimeResponds,
      CanCan::ControllerAdditions
    ].each { |m| include m }

    # Class used to handle API response, and specific error code
    class InvalidAPIRequest < StandardError
      attr_reader :code

      # Public: constructor
      # message - message that gets shown in the response
      # code    - error code returned in the JSON response
      def initialize(message, code = 500)
        super(message)
        @code = code
      end
    end

    # Override CanCan method to provide custom Ability files
    def current_ability
      @current_ability ||= Ability.build_ability_for(current_user)
    end

    # Hash with exception types and status codes
    EXCEPTIONS = {
      ActiveRecord::RecordNotFound => 404,
      ActiveRecord::RecordInvalid => 422,
      ActiveRecord::DeleteRestrictionError => 422,
      ArgumentError => 422,
      CanCan::AccessDenied => 403
    }.freeze

    # Exception handler for invalid api requests, forms a message like
    # in the same way as our services do
    rescue_from Exception do |ex|
      respond_to do |format|
        format.json do
          err_code = 500
          code = ex.respond_to?(:code) ? ex.code : err_code
          code = EXCEPTIONS[ex.class] if EXCEPTIONS.key?(ex.class)

          resp_hash = { success: false, errors: [ex.message] }

          puts "API Response #{code} is #{resp_hash.inspect} backtrace is #{ex.backtrace.inspect}"
          resp_hash['stack_trace'] = ex.backtrace if Rails.env.development?

          render text: resp_hash.to_json, status: code
        end
      end
    end

    # Public: generates the json response
    # obj - object that contains the data sent in a request
    # returns - data in json format
    def build_data_object(obj)
      { success: true, data: obj }.to_json
    end

    # Public: generates error response
    # obj - object that contains the data sent in a request
    # returns json
    def build_error_object(obj)
      obj_errors = []
      obj.errors.messages.each do |k, v|
        obj_errors << "#{k} #{v.join}"
      end
      { success: false, errors: obj_errors }.to_json
    end
  end
end
