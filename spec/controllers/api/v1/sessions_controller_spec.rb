require 'spec_helper'

describe Api::V1::SessionsController do
  let(:format) { :json }
  describe 'POST #create' do
    let(:http_method) { :post }
    let(:action) { :create }
    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    context 'when the credentials are correct' do
      it 'returns the user record corresponding to the given credentials' do
        credentials = { email: @user.email, password: @user.password }
        send_request(http_method, action, credentials, format)
        @user.reload

        expected_response = {
          'success' => true,
          'data' => {
            auth_token: @user.auth_token
          }
        }

        json_response = parsed_response(response)
        expect(json_response[:data]).to eql expected_response['data']
        expect(response.status).to eql 200
      end

      it 'returns error if user is inactive' do
        user = FactoryGirl.create(:user, active: false)
        credentials = { email: user.email, password: user.password }
        send_request(http_method, action, credentials, format)
        expect(response.status).to eql 401
      end
    end

    context 'when the credentials are incorrect' do
      before(:each) do
        send_request(
          http_method, action,
          {
            email: @user.email,
            password: 'invalidpassword'
          },
          format
        )
      end

      it 'returns a json with an error' do
        expect(parsed_response(response)).to have_key(:errors)
        expect(response.status).to eql 401
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:http_method) { :delete }
    let(:action) { :destroy }
    before(:each) do
      @user = FactoryGirl.create :user
      @user.generate_authentication_token!
      @user.save
      sign_in @user
    end

    context 'when the credentials are correct' do
      before(:each) do
        send_request(http_method, action, {  id: @user.auth_token }, format)
      end

      it { should respond_with 204 }
    end

    context 'when the token is invalid' do
      before(:each) do
        send_request(http_method, action, {  id: 1 }, format)
      end

      it 'returns a json with an error' do
        expect(parsed_response(response)).to have_key(:errors)
        expect(response.status).to eql 404
      end
    end
  end
end
