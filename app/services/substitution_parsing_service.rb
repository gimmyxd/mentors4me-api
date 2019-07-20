# frozen_string_literal: true

class SubstitutionParsingService
  def initialize(options)
    @options = options
  end

  def call
    parse_hash
  end

  private

  def parse_hash
    result = []
    @options.each do |key, value|
      hash_pair = {
        key: "-#{key}-",
        value: value
      }
      result << hash_pair
    end
    result
  end
end
