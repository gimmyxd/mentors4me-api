require 'spec_helper'

describe Api::V1::SessionsController do
  describe 'POST #create' do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    context 'when the credentials are correct' do
      it 'returns the user record corresponding to the given credentials' do
        credentials = { email: @user.email, password: @user.password }
        post :create, credentials, format: :json
        @user.reload

        expected_response = {
          'success' => true,
          'data' => {
            auth_token: @user.auth_token
          }
        }

        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:data]).to eql expected_response['data']
        expect(response.status).to eql 200
      end

      it 'returns error if user is inactive' do
        user = FactoryGirl.create(:user, active: false)
        post :create, email: user.email, password: user.password, format: :json

        expect(response.status).to eql 401
      end
    end

    context 'when the credentials are incorrect' do
      before(:each) do
        post :create, email: @user.email, password: 'invalidpassword', format: :json
      end

      it 'returns a json with an error' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response).to have_key(:errors)
        expect(response.status).to eql 401
      end
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      @user = FactoryGirl.create :user
      @user.generate_authentication_token!
      @user.save
      sign_in @user
    end

    context 'when the credentials are correct' do
      before(:each) do
        delete :destroy, id: @user.auth_token
      end

      it { should respond_with 204 }
    end

    context 'when the token is invalid' do
      before(:each) do
        delete :destroy, id: 1, format: :json
      end

      it 'returns a json with an error' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response).to have_key(:errors)
        expect(response.status).to eql 404
      end
    end
  end
end
