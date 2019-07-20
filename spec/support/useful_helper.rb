# frozen_string_literal: true
module UsefulHelper
  CD = Custom::Constants::Default
  CR = Custom::Constants::Role
  CP = Custom::Constants::Proposal
  CC = Custom::Constants::Context

  def send_request(http_method, action, options = {}, format = nil, session = {})
    options[:format] = format if format.present?

    case http_method
    when :post
      post action, { params: options }
    when :put
      put action, { params: options }
    when :get
      get action, { params: options }
    when :delete
      delete action, { params: options }
    end
  end

  def parsed_response(response)
    JSON.parse(response.body, symbolize_names: true)
  end
end
