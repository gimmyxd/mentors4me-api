# frozen_string_literal: true

class ApplicationMailer < ActionMailer::MailDeliveryJob
  class << self
    include SendGrid

    def perform(email, template_id, substitutions = {})
      mail = Mail.new
      mail.from = Email.new(email: ENV['EMAIL_FROM'])
      personalization = Personalization.new
      personalization.add_to(Email.new(email: email))
      substitutions.each do |substitution|
        personalization.add_substitution(Substitution.new(substitution))
      end
      mail.add_personalization(personalization)
      mail.template_id = template_id

      sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
      begin
        response = sg.client.mail._('send').post(request_body: mail.to_json)
      rescue StandardError => e
        Rails.logger e.message
      end

      Rails.logger.info response.status_code
      Rails.logger.info response.body
      Rails.logger.info response.headers
    end
  end
end
