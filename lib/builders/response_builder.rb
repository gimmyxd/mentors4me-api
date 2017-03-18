# frozen_string_literal: true
module Builders
  module ResponseBuilder
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
  end
end
