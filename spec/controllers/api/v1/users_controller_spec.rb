# frozen_string_literal: true

require 'spec_helper'

describe Api::V1::UsersController do
  let(:format) { :json }

  before do
    @user = FactoryBot.create(:user, :admin_user)
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
      @user[:auth_token_created_at] = Time.zone.now - 25.hours
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
      user1 = FactoryBot.create(:user, :mentor_user)
      user2 = FactoryBot.create(:user, :organization_user)

      expected_response = {
        success: true,
        data: [
          {
            id: @user.id,
            email: @user.email,
            active: true,
            role: ['admin']
          },
          {
            id: user1.id,
            email: user1.email,
            role: ['mentor'],
            active: true,
            first_name: user1.mentor.first_name,
            last_name: user1.mentor.last_name,
            phone_number: user1.mentor.phone_number,
            city: user1.mentor.city,
            description: user1.mentor.description,
            skills: user1.mentor.skills.pluck(:name).sort,
            facebook: user1.mentor.facebook,
            linkedin: user1.mentor.linkedin,
            organization: user1.mentor.organization,
            position: user1.mentor.position,
            occupation: user1.mentor.occupation,
            availability: user1.mentor.availability
          },
          {
            id: user2.id,
            email: user2.email,
            role: ['organization'],
            active: true,
            name: user2.organization.name,
            asignee: user2.organization.asignee,
            phone_number: user2.organization.phone_number,
            city: user2.organization.city,
            facebook: user2.organization.facebook,
            description: user2.organization.description
          }
        ]
      }

      send_request(http_method, action, {}, format)
      expect(parsed_response(response).sort).to eql expected_response.sort
      expect(response.status).to be 200
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
          active: true,
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

  describe 'PUT/PATCH activate' do
    let(:http_method) { :put }
    let(:action) { :activate }
    let!(:user) { FactoryBot.create(:user, active: false) }
    let(:params) { { id: user.id } }

    context 'not found' do
      it 'returns 404' do
        send_request(http_method, action, { id: 'not_found' }, format)
        expect(response.status).to be 404
      end

      it 'returns the correct error key' do
        send_request(http_method, action, { id: 'not_found' }, format)
        expect(parsed_response(response)[:errors].first).to eq('record_not_found')
      end
    end

    context 'admin' do
      it 'is success' do
        send_request(http_method, action, params, format)
        expect(response.status).to be 200
      end

      it 'sets active to true' do
        send_request(http_method, action, params, format)
        expect(user.reload.active).to be(true)
      end
    end

    context 'as mentor' do
      it 'does not have access' do
        mentor = FactoryBot.create(:user, :mentor_user)
        request.headers['Authorization'] = mentor.auth_token
        send_request(http_method, action, params, format)
        expect(response.status).to be 403
      end
    end

    context 'as organization' do
      it 'does not have access' do
        organization = FactoryBot.create(:user, :organization_user)
        request.headers['Authorization'] = organization.auth_token
        send_request(http_method, action, params, format)
        expect(response.status).to be 403
      end
    end
  end

  describe 'PUT/PATCH deactivate' do
    let(:http_method) { :put }
    let(:action) { :deactivate }
    let!(:user) { FactoryBot.create(:user, active: true) }
    let(:params) { { id: user.id } }

    context 'not found' do
      it 'returns 404' do
        send_request(http_method, action, { id: 'not_found' }, format)
        expect(response.status).to be 404
      end

      it 'returns the correct error key' do
        send_request(http_method, action, { id: 'not_found' }, format)
        expect(parsed_response(response)[:errors].first).to eq('record_not_found')
      end
    end

    context 'admin' do
      it 'is success' do
        send_request(http_method, action, params, format)
        expect(response.status).to be 200
      end

      it 'sets active to true' do
        send_request(http_method, action, params, format)
        expect(user.reload.active).to be(false)
      end
    end

    context 'as mentor' do
      it 'does not have access' do
        mentor = FactoryBot.create(:user, :mentor_user)
        request.headers['Authorization'] = mentor.auth_token
        send_request(http_method, action, params, format)
        expect(response.status).to be 403
      end

      it 'deactivates personal account' do
        mentor = FactoryBot.create(:user, :mentor_user)
        request.headers['Authorization'] = mentor.auth_token
        send_request(http_method, action, { id: mentor.id }, format)
        expect(response.status).to be 200
        expect(mentor.reload.active).to be(false)
      end
    end

    context 'as organization' do
      it 'does not have access' do
        organization = FactoryBot.create(:user, :organization_user)
        request.headers['Authorization'] = organization.auth_token
        send_request(http_method, action, params, format)
        expect(response.status).to be 403
      end

      it 'deactivates personal account' do
        organization = FactoryBot.create(:user, :organization_user)
        request.headers['Authorization'] = organization.auth_token
        send_request(http_method, action, { id: organization.id }, format)
        expect(response.status).to be 200
        expect(organization.reload.active).to be(false)
      end
    end
  end

  describe 'PUT/PATCH password' do
    let(:http_method) { :put }
    let(:action) { :password }

    context 'admin' do
      let(:admin) { FactoryBot.create(:user) }

      it 'successfully updates a user\'s password' do
        params = {
          id: admin.id,
          current_password: admin.password,
          password: 'newpassword',
          password_confirmation: 'newpassword'
        }
        send_request(http_method, action, params, format)
        expect(response.status).to be 200
        expect(admin.reload.valid_password?(params[:password])).to be true
      end

      it 'raises proper errors when request does not contain any password params' do
        send_request(http_method, action, { id: admin.id }, format)
        expect(parsed_response(response)).to have_key(:errors)
        expect(response.status).to be 422
      end
    end

    context 'mentor' do
      let(:mentor) { FactoryBot.create(:user, :mentor_user) }
      let(:another_mentor) { FactoryBot.create(:user, :mentor_user) }

      before do
        request.headers['Authorization'] = mentor.auth_token
      end

      it 'successfully updates a user\'s password' do
        params = {
          id: mentor.id,
          current_password: mentor.password,
          password: 'newpassword',
          password_confirmation: 'newpassword'
        }
        send_request(http_method, action, params, format)
        expect(response.status).to be 200
        expect(mentor.reload.valid_password?(params[:password])).to be true
      end

      it 'does not allow changing password of other user' do
        send_request(http_method, action, { id: another_mentor.id }, format)
        expect(response.status).to be 403
      end

      it 'raises proper errors when request does not contain any password params' do
        send_request(http_method, action, { id: mentor.id }, format)
        expect(parsed_response(response)).to have_key(:errors)
        expect(response.status).to be 422
      end
    end

    context 'organization' do
      let(:organization) { FactoryBot.create(:user, :organization_user) }
      let(:another_organization) { FactoryBot.create(:user, :organization_user) }

      before do
        request.headers['Authorization'] = organization.auth_token
      end

      it 'successfully updates a user\'s password' do
        params = {
          id: organization.id,
          current_password: organization.password,
          password: 'newpassword',
          password_confirmation: 'newpassword'
        }
        send_request(http_method, action, params, format)
        expect(response.status).to be 200
        expect(organization.reload.valid_password?(params[:password])).to be true
      end

      it 'does not allow changing password of other user' do
        send_request(http_method, action, { id: another_organization.id }, format)
        expect(response.status).to be 403
      end

      it 'raises proper errors when request does not contain any password params' do
        send_request(http_method, action, { id: organization.id }, format)
        expect(parsed_response(response)).to have_key(:errors)
        expect(response.status).to be 422
      end
    end
  end
end
