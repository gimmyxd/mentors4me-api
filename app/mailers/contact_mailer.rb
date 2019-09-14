# frozen_string_literal: true

class ContactMailer < ApplicationMailer
  class << self
    def send_notification(email, options)
      parser = SubstitutionParsingService.new(options)
      substitutions = parser.call

      perform(email, '954b0d8e-85ca-4388-99bc-2fac4ef758a2', substitutions)
    end
  end
end
