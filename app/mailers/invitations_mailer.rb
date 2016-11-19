class InvitationsMailer < ApplicationMailer
  default from: ENV['EMAIL_FROM']

  def send_invitation(email, invitation_token)
    @url = "#{ENV['FRONTEND_URL']}/#{invitation_token}"
    mail(to: email, subject: 'Mentor Invitation')
  end
end
