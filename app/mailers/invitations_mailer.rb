class InvitationsMailer < ApplicationMailer
  default from: 'mentors4me@gmail.com'

  def send_invitation(email)
    mail(to: email, subject: 'Mentor Invitation')
  end
end
