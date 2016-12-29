class InvitationsMailer < ApplicationMailer
  default from: ENV['EMAIL_FROM']

  def send_invitation(email, auth_token)
    @url = "#{ENV['FRONTEND_URL']}/#{auth_token}"
    mail(to: email, subject: 'Mentor Invitation')
  end
end
