# frozen_string_literal: true
class ApplicationMailer < ActionMailer::Base
  include SendGrid

  def perfrom(email, template_id, substitutions = {})
    mail = Mail.new
    mail.from = Email.new(email: ENV['EMAIL_FROM'])
    personalization = Personalization.new
    personalization.to = Email.new(email: email)
    substitutions.each do |substitution|
      personalization.substitutions = Substitution.new(substitution)
    end
    mail.personalizations = personalization
    mail.template_id = template_id

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    begin
      response = sg.client.mail._('send').post(request_body: mail.to_json)
    rescue StandardError => e
      puts e.message
    end

    puts response.status_code
    puts response.body
    puts response.headers
  end
end
