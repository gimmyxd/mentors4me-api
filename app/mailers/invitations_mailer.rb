class InvitationsMailer < ApplicationMailer
  default from: 'mentors4me@gmail.com'

  def send_invitation(email, _invitation_token)
    mail(to: email, subject: 'Mentor Invitation')
  end
end
