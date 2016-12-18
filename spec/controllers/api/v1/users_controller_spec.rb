require 'spec_helper'

describe Api::V1::UsersController do
  before :each do
    @user = FactoryGirl.create(:user)
    request.headers['Authorization'] = @user.auth_token
  end

  describe 'GET #show' do
    it 'returns the information about a reporter on a hash' do
      get :show, id: @user.id, format: :json
      user_response = JSON.parse(response.body, symbolize_names: true)
      expect(response.status).to eq 200
      expect(user_response[:data][:email]).to eql @user.email
    end

    it 'timeout after 24 hours' do
      @user[:auth_token_created_at] = Time.now - 25.hours
      @user.save
      get :show, id: @user.id, format: :json
      expect(response.status).to eq 401
    end

    it 'returns 404 if user is not found' do
      get :show, id: 'invalid_id', format: :json
      expect(response.status).to eq 404
    end
  end

  describe 'GET #index' do
    it 'returns the information about all users on a hash' do
      user1 = FactoryGirl.create(:user, :admin)
      user2 = FactoryGirl.create(:user, :admin)

      expected_response = {
        success: true,
        data: [
          {
            id: @user.id,
            email: @user.email,
            role: @user.role
          },
          {
            id: user1.id,
            email: user1.email,
            role: user1.role
          },
          {
            id: user2.id,
            email: user2.email,
            role: user2.role
          }
        ]
      }

      get :index, format: :json

      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response.sort).to eql expected_response.sort
      expect(response.status).to eql 200
    end
  end

  describe 'GET /me' do
    it 'returns the information about current user' do
      expected_response = {
        success: true,
        data: {
          id: @user.id,
          email: @user.email,
          role: @user.role
        }
      }

      get :me, format: :json
      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(response.status).to eq 200
      expect(json_response).to eql expected_response
    end

    it 'returns 401 if token is invalid' do
      request.headers['Authorization'] = '123'
      get :me, format: :json
      expect(response.status).to eq 401
    end
  end

  describe 'PUT/PATCH password' do
    it 'successfully updates a user\'s password' do
      params = {
        id: @user.id,
        current_password: @user.password,
        password: 'newpassword',
        password_confirmation: 'newpassword'
      }
      put :password, params, format: :json

      expect(response.status).to eql 200
      expect(@user.reload.valid_password?(params[:password])).to eql true
    end

    it 'raises proper errors when request does not contain any password params' do
      put :password, id: @user.id, format: :json
      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response).to have_key(:errors)
      expect(response.status).to eql 422
    end
  end
end
