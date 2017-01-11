class InvitationsMailer < ApplicationMailer
  def send_invitation(email, auth_token)
    url = "#{ENV['FRONTEND_URL']}/#!/mentors/register/#{auth_token}"

    mail = Mail.new
    mail.from = Email.new(email: ENV['EMAIL_FROM'])
    personalization = Personalization.new
    personalization.to = Email.new(email: email)
    personalization.substitutions = Substitution.new(key: '-url-', value: url)
    mail.personalizations = personalization
    mail.template_id = '1ec461ed-71d6-4a32-b77e-024da1f6210c'

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
