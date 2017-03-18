# frozen_string_literal: true
describe Api::V1::ContextsController do
  let(:format) { :json }
  context 'unauthorized' do
    let(:context) { FactoryGirl.create(:context) }
    before do
      send_request(:get, :show, { id: context.id }, format)
    end
    it 'returns 401' do
      expect(response.status).to eql(401)
    end

    it 'returns the error key' do
      expect(parsed_response(response)[:errors].first).to eq('unauthorized')
    end
  end
end
