# frozen_string_literal: true
module SharedMethods
  CD = Custom::Constants::Default
  CR = Custom::Constants::Role
  CP = Custom::Constants::Proposal
  CC = Custom::Constants::Context
  CU = Custom::Constants::User

  def self.format_date(value, format = '%d/%m/%Y %H:%M:%S')
    raise ArgumentError if value.blank? || !(value.is_a? Time)
    value.strftime(format)
  rescue ArgumentError
    return value
  end
end
