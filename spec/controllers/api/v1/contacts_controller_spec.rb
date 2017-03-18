# frozen_string_literal: true
describe Api::V1::ContactsController, type: :controller do
  let(:format) { :json }
  let(:http_method) { :post }
  let(:action) { :create }

  context 'success' do
    it 'returns 200' do
      params = {
        first_name: 'test',
        last_name: 'test',
        email: 'test@email.com',
        message: 'test message'
      }
      send_request(http_method, action, params, format)
      expect(response.status).to eq(200)
    end
  end

  context 'validations' do
    before do
      send_request(http_method, action, {}, format)
    end
    it 'returns status 422' do
      expect(response.status).to eq(422)
    end
    it 'returns an array of erros with missing fields' do
      expected_response =
        [
          'first_name.blank',
          'last_name.blank',
          'email.blank',
          'message.blank'
        ]
      expect(parsed_response(response)[:errors]).to eq(expected_response)
    end
  end
end
