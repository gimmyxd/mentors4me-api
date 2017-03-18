# frozen_string_literal: true
describe SubstitutionParsingService do
  it 'generates an array of hashes to use as sengrid substitutions' do
    options = {
      name: 'Laury Walter',
      organization_name: 'new world',
      context_description: 'sadsadsadsadsa',
      organization_adress: 'test',
      organization_description: 'password'
    }

    expected_result = [
      { key: '-name-', value: 'Laury Walter' },
      { key: '-organization_name-', value: 'new world' },
      { key: '-context_description-', value: 'sadsadsadsadsa' },
      { key: '-organization_adress-', value: 'test' },
      { key: '-organization_description-', value: 'password' }
    ]
    parser = SubstitutionParsingService.new(options)
    expect(parser.call).to eql(expected_result)
  end
end
