# frozen_string_literal: true

require 'spec_helper'

describe Api::V1::OrganizationsController do
  let(:format) { :json }

  before do
    @user = FactoryBot.create(:user, :organization_user)
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

    it 'returns 404 if user is not found' do
      send_request(http_method, action, { id: 'invalid_id' }, format)
      expect(response.status).to eq 404
    end
  end

  describe 'GET #index' do
    let(:http_method) { :get }
    let(:action) { :index }

    it 'returns the information about all users on a hash' do
      user1 = FactoryBot.create(:user, :organization_user)
      user2 = FactoryBot.create(:user, :organization_user)
      FactoryBot.create(:user, :mentor_user)
      FactoryBot.create(:user, :admin_user)

      expected_response = {
        success: true,
        data: [
          {
            id: @user.id,
            email: @user.email,
            role: ['organization'],
            active: true,
            name: @user.organization.name,
            asignee: @user.organization.asignee,
            phone_number: @user.organization.phone_number,
            city: @user.organization.city,
            facebook: 'www.facebook.com/organization',
            description: @user.organization.description
          },
          {
            id: user1.id,
            email: user1.email,
            role: ['organization'],
            active: true,
            name: user1.organization.name,
            asignee: user1.organization.asignee,
            phone_number: user1.organization.phone_number,
            city: user1.organization.city,
            facebook: 'www.facebook.com/organization',
            description: user1.organization.description
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
            facebook: 'www.facebook.com/organization',
            description: user2.organization.description
          }
        ]
      }

      send_request(http_method, action, {}, format)
      expect(parsed_response(response).sort).to eql expected_response.sort
      expect(response.status).to be 200
    end
  end

  describe 'POST #create' do
    let(:http_method) { :post }
    let(:action) { :create }

    it 'successfully creates an organization user' do
      user_params = FactoryBot.attributes_for(:user)
      organization_params = FactoryBot.attributes_for(:organization)
      user_params.merge!(organization_params)
      expected_response = {
        success: true,
        data:
          {
            email: user_params[:email],
            role: ['organization'],
            active: true,
            name: user_params[:name],
            asignee: user_params[:asignee],
            phone_number: user_params[:phone_number],
            city: user_params[:city],
            facebook: user_params[:facebook],
            description: user_params[:description]
          }
      }

      send_request(http_method, action, user_params, format)
      json_response = parsed_response(response)
      json_response[:data] = json_response[:data].except(:id)
      expect(response.status).to be 201
      expect(json_response).to eql expected_response
    end

    it 'renders proper errors' do
      allow_any_instance_of(User).to receive(:create).and_return(false)
      send_request(http_method, action, {}, format)
      expect(parsed_response(response)).to have_key(:errors)
      expect(response.status).to be 422
    end
  end

  describe 'PUT/PATCH #update' do
    let(:http_method) { :put }
    let(:action) { :update }

    it 'successfully updates an user' do
      user = FactoryBot.create(:user, :organization_user)
      request.headers['Authorization'] = user.auth_token
      organization_params = FactoryBot.attributes_for(:organization)
      organization_params[:id] = user.id

      expected_response = {
        success: true,
        data:
          {
            id: user.id,
            email: user.email,
            role: ['organization'],
            active: true,
            name: organization_params[:name],
            asignee: organization_params[:asignee],
            phone_number: organization_params[:phone_number],
            city: organization_params[:city],
            facebook: organization_params[:facebook],
            description: organization_params[:description]
          }
      }

      send_request(http_method, action, organization_params, format)

      json_response = parsed_response(response)
      expect(response.status).to be 200
      expect(json_response).to eql expected_response
    end

    it 'renders proper errors' do
      allow_any_instance_of(User).to receive(:update).and_return(false)
      user = FactoryBot.create(:user, :organization_user)
      request.headers['Authorization'] = user.auth_token

      send_request(http_method, action, { id: user.id }, format)

      expect(parsed_response(response)).to have_key(:errors)
      expect(response.status).to be 422
    end

    it 'returns 404 when trying to update an user that does not exist' do
      send_request(http_method, action, { id: 'invalid_id' }, format)
      json_response = parsed_response(response)
      expect(response.status).to eq 404
      expect(json_response[:errors].first).to eql('record_not_found')
    end

    it 'returns 403 when trying to update another' do
      user = FactoryBot.create(:user, :organization_user)
      send_request(http_method, action, { id: user.id }, format)
      json_response = parsed_response(response)
      expect(response.status).to eq 403
      expect(json_response[:errors].first).to eql('access_denied')
    end
  end

  describe 'PUT/PATCH activate' do
    let(:http_method) { :put }
    let(:action) { :activate }
    let(:admin) { FactoryBot.create(:user, :admin_user) }
    let!(:user) { FactoryBot.create(:user, :organization_user, active: false) }
    let(:params) { { id: user.id } }

    context 'not found' do
      it 'returns 404' do
        request.headers['Authorization'] = admin.auth_token
        send_request(http_method, action, { id: 'not_found' }, format)
        expect(response.status).to be 404
      end

      it 'returns the correct error key' do
        request.headers['Authorization'] = admin.auth_token
        send_request(http_method, action, { id: 'not_found' }, format)
        expect(parsed_response(response)[:errors].first).to eq('record_not_found')
      end
    end

    context 'admin' do
      it 'is success' do
        request.headers['Authorization'] = admin.auth_token
        send_request(http_method, action, params, format)
        expect(response.status).to be 200
      end

      it 'sets active to true' do
        request.headers['Authorization'] = admin.auth_token
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
    let(:admin) { FactoryBot.create(:user, :admin_user) }
    let!(:user) { FactoryBot.create(:user, :organization_user, active: true) }
    let(:params) { { id: user.id } }

    context 'not found' do
      it 'returns 404' do
        request.headers['Authorization'] = admin.auth_token
        send_request(http_method, action, { id: 'not_found' }, format)
        expect(response.status).to be 404
      end

      it 'returns the correct error key' do
        request.headers['Authorization'] = admin.auth_token
        send_request(http_method, action, { id: 'not_found' }, format)
        expect(parsed_response(response)[:errors].first).to eq('record_not_found')
      end
    end

    context 'admin' do
      it 'is success' do
        request.headers['Authorization'] = admin.auth_token
        send_request(http_method, action, params, format)
        expect(response.status).to be 200
      end

      it 'sets active to true' do
        request.headers['Authorization'] = admin.auth_token
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
end
