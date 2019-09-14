# frozen_string_literal: true

class ProposalsMailer < ApplicationMailer
  class << self
    def send_confirmation(email, options = {})
      parser = SubstitutionParsingService.new(options)
      substitutions = parser.call

      perform(email, '38a604d5-7492-42e3-8529-550e1e0c58df', substitutions)
    end
  end
end
