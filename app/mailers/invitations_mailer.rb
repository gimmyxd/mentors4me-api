# frozen_string_literal: true
class InvitationsMailer < ApplicationMailer
  def send_invitation(email, auth_token)
    url = "#{ENV['FRONTEND_URL']}/#/mentors/register/#{auth_token}"
    email.gsub!(/\+(.*?)\@/, '@')

    substitutions = [
      {
        key: '-url-',
        value: url
      }
    ]

    perfrom(email, '1ec461ed-71d6-4a32-b77e-024da1f6210c', substitutions)
  end
end
