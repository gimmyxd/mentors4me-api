# frozen_string_literal: true

class OrganizationsMailer < ApplicationMailer
  class << self
    def send_confirmation(email, name)
      email.gsub!(/\+(.*?)@/, '@')
      substitutions = [
        {
          key: '-name-',
          value: name
        }
      ]

      perform(email, 'd5c37b6b-6e8a-4f5d-96ea-ad690bf9f574', substitutions)
    end

    def send_unread_messages(email, options)
      email.gsub!(/\+(.*?)@/, '@')
      parser = SubstitutionParsingService.new(options)
      substitutions = parser.call

      perform(email, '30c68024-71af-46a1-979d-a5b4975c17bb', substitutions)
    end
  end
end
