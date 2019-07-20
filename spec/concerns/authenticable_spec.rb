# frozen_string_literal: true

require 'spec_helper'

class Authentication
  include Authenticable
end

describe Authenticable, type: :controller do
  subject { authentication }

  let(:authentication) { Authentication.new }

  describe 'unauthorized authentication' do
    before do
      @user = FactoryBot.create :user
      allow(authentication).to receive(:current_user).and_return(nil)
      allow(response).to receive(:response_code).and_return(401)
      allow(response).to receive(:body).and_return(
        {
          success: false,
          errors: 'unauthorized'
        }.to_json
      )
      allow(authentication).to receive(:response).and_return(response)
    end

    it 'renders a json error message' do
      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:success]).to be false
      expect(json_response[:errors]).to eql('unauthorized')
    end

    it { is_expected.to respond_with 401 }
  end

  describe 'authorized authentication' do
    before do
      @user = FactoryBot.create :user
      allow(authentication).to receive(:current_user).and_return(@user)
      allow(response).to receive(:response_code).and_return(200)
      allow(response).to receive(:body).and_return({ success: true }.to_json)
      allow(authentication).to receive(:response).and_return(response)
    end

    it 'renders successful response' do
      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:success]).to be true
    end

    it { is_expected.to respond_with 200 }
  end

  describe 'After 24h' do
    before do
      @user = FactoryBot.create :user
      @user.generate_authentication_token!
      @user[:auth_token_created_at] = Time.zone.now - 25.hours
      @user.save!
    end

    it 'renders unauthorized' do
      response = authentication.validate_token(@user.auth_token)
      expect(response).to eq false
    end
  end

  describe '#current_user' do
    before do
      @user = FactoryBot.create :user
      request.headers['Authorization'] = @user.auth_token
      allow(authentication).to receive(:request).and_return(request)
    end

    it 'returns the user from the authorization header' do
      expect(authentication.current_user.auth_token).to eql @user.auth_token
    end
  end
end
