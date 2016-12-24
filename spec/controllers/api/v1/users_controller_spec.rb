require 'spec_helper'

describe Api::V1::UsersController do
  let(:format) { :json }
  before :each do
    @user = FactoryGirl.create(:user, :admin_user)
    request.headers['Authorization'] = @user.auth_token
  end

  describe 'GET #show' do
    let(:http_method) { :get }
    let(:action) { :show }

    it 'returns the information about a reporter on a hash' do
      send_request(http_method, action, { id: @user.id }, format)
      user_response = parsed_response(response)
      expect(response.status).to eq 200
      expect(user_response[:data][:email]).to eql @user.email
    end

    it 'timeout after 24 hours' do
      @user[:auth_token_created_at] = Time.now - 25.hours
      @user.save
      send_request(http_method, action, { id: @user.id }, format)
      expect(response.status).to eq 401
    end

    it 'returns 404 if user is not found' do
      send_request(http_method, action, { id: 'invalid_id' }, format)
      expect(response.status).to eq 404
    end
  end

  describe 'GET #index' do
    let(:http_method) { :get }
    let(:action) { :index }

    it 'returns the information about all users on a hash' do
      user1 = FactoryGirl.create(:user, :mentor_user)
      user2 = FactoryGirl.create(:user, :organization_user)

      expected_response = {
        success: true,
        data: [
          {
            id: @user.id,
            email: @user.email,
            role: ['admin']
          },
          {
            id: user1.id,
            email: user1.email,
            role: ['mentor'],
            profile_id: user1.profile.id,
            first_name: user1.profile.first_name,
            last_name: user1.profile.last_name,
            phone_number: user1.profile.phone_number,
            city: user1.profile.city,
            description: user1.profile.description,
            facebook: user1.profile.facebook,
            linkedin: user1.profile.linkedin
          },
          {
            id: user2.id,
            email: user2.email,
            role: ['organization'],
            organization_id: user2.organization.id,
            name: user2.organization.name,
            asignee: user2.organization.asignee,
            phone_number: user2.organization.phone_number,
            city: user2.organization.city,
            description: user2.organization.description
          }
        ]
      }

      send_request(http_method, action, {}, format)

      expect(parsed_response(response).sort).to eql expected_response.sort
      expect(response.status).to eql 200
    end
  end

  describe 'GET /me' do
    let(:http_method) { :get }
    let(:action) { :me }

    it 'returns the information about current user' do
      expected_response = {
        success: true,
        data: {
          id: @user.id,
          email: @user.email,
          role: ['admin']
        }
      }

      send_request(http_method, action, {}, format)

      expect(response.status).to eq 200
      expect(parsed_response(response)).to eql expected_response
    end

    it 'returns 401 if token is invalid' do
      request.headers['Authorization'] = '123'
      send_request(http_method, action, {}, format)
      expect(response.status).to eq 401
    end
  end

  describe 'PUT/PATCH password' do
    let(:http_method) { :put }
    let(:action) { :password }

    it 'successfully updates a user\'s password' do
      params = {
        id: @user.id,
        user: {
          current_password: @user.password,
          password: 'newpassword',
          password_confirmation: 'newpassword'
        }
      }
      send_request(http_method, action, params, format)
      expect(response.status).to eql 200
      expect(@user.reload.valid_password?(params[:user][:password])).to eql true
    end

    it 'raises proper errors when request does not contain any password params' do
      send_request(http_method, action, { user: { password: 'ana' }, id: @user.id }, format)
      expect(parsed_response(response)).to have_key(:errors)
      expect(response.status).to eql 422
    end
  end
end
