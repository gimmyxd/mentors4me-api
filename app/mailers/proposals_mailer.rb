class ProposalsMailer < ApplicationMailer
  def send_confirmation(email, options = {})
    parser = SubstitutionParsingService.new(options)
    substitutions = parser.call

    perfrom(email, '38a604d5-7492-42e3-8529-550e1e0c58df', substitutions)
  end
end
