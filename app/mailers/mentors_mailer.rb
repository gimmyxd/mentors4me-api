# frozen_string_literal: true

class MentorsMailer < ApplicationMailer
  def send_confirmation(email, name)
    email.gsub!(/\+(.*?)\@/, '@')
    substitutions = [
      {
        key: '-name-',
        value: name
      }
    ]

    perfrom(email, '6e3e2c04-c214-4757-8640-805f89e76faa', substitutions)
  end

  def send_context_confirmation(email, options)
    email.gsub!(/\+(.*?)\@/, '@')
    parser = SubstitutionParsingService.new(options)
    substitutions = parser.call

    perfrom(email, '84140a18-c858-4b74-bb2b-b55a3c480137', substitutions)
  end

  def send_unread_messages(email, options)
    email.gsub!(/\+(.*?)\@/, '@')
    parser = SubstitutionParsingService.new(options)
    substitutions = parser.call

    perfrom(email, '30c68024-71af-46a1-979d-a5b4975c17bb', substitutions)
  end
end
