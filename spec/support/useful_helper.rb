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
      post action, { params: options }, session: session
    when :put
      put action, { params: options }, session: session
    when :get
      get action, { params: options }, session: session
    when :delete
      delete action, { params: options }, session: session
    end
  end

  def parsed_response(response)
    JSON.parse(response.body, symbolize_names: true)
  end
end
