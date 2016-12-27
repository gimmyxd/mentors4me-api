require 'new_relic/agent/instrumentation/controller_instrumentation'
require 'new_relic/agent/instrumentation/rails3/action_controller'
require 'new_relic/agent/instrumentation/rails3/errors'

module Api
  class BaseController < ActionController::API
    # minimum required controller functionality for rendering, proper mime-type
    # setting, and rescue_from functionality
    include Authenticable
    include SharedMethods

    MODULES = [
      ActionController::MimeResponds,
      CanCan::ControllerAdditions,
      NewRelic::Agent::Instrumentation::ControllerInstrumentation,
      NewRelic::Agent::Instrumentation::Rails3::ActionController,
      NewRelic::Agent::Instrumentation::Rails3::Errors,
      HasScope
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

    # Exception handler for invalid api requests
    rescue_from Exception do |ex|
      respond_to do |format|
        format.json do
          err_code = 500
          code = ex.respond_to?(:code) ? ex.code : err_code
          code = CD::EXCEPTIONS[ex.class] if CD::EXCEPTIONS.key?(ex.class)
          resp_hash = if CD::EXCEPTIONS.key?(ex.class)
                        { success: false, errors: Array(CD::EXCEPTIONS_KEYS[ex.class]) }
                      else
                        { success: false, errors: Array(ex.message) }
                      end

          if Rails.env.development?
            puts "API Response #{code} is #{resp_hash.inspect} backtrace is #{ex.backtrace.inspect}"
            resp_hash['stack_trace'] = ex.backtrace
          end

          render plain: resp_hash.to_json, status: code
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
      keys = obj.errors.details.keys.map(&:to_s).collect do |key|
        key.remove("#{controller_name.singularize}.")
      end
      values = obj.errors.details.values.collect { |value| value.first[:error] }.map(&:to_s)
      error_response = keys.zip(values).map { |arr| arr.join('.') }
      { success: false, errors: error_response }.to_json
    end

    def valid_date?(date, format = '%Y-%m-%d')
      date = Date.parse(date).to_s
      DateTime.strptime(date, format)
      raise ArgumentError unless /^\d{4}-\d{2}-\d{2}$/ =~ date
    end
  end
end
