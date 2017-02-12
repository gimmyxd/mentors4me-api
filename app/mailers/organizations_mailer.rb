class OrganizationsMailer < ApplicationMailer
  def send_confirmation(email, name)
    email.gsub!(/\+(.*?)\@/, '@')
    substitutions = [
      {
        key: '-name-',
        value: name
      }
    ]

    perfrom(email, 'd5c37b6b-6e8a-4f5d-96ea-ad690bf9f574', substitutions)
  end
end
