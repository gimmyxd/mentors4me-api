# frozen_string_literal: true

describe Api::V1::MentorsController do
  let(:format) { :json }

  describe 'GET #show' do
    let(:http_method) { :get }
    let(:action) { :show }

    context 'success' do
      let(:mentor) { FactoryBot.create(:user, :mentor_user) }

      before do
        send_request(http_method, action, { id: mentor.id }, format)
      end

      it 'request is successfully made' do
        expect(response.status).to be(200)
      end

      it 'returns the information about a reporter on a hash' do
        expect(parsed_response(response)[:data][:email]).to eql(mentor.email)
      end
    end

    context 'mentor not found' do
      before do
        send_request(http_method, action, { id: 'invalid_id' }, format)
      end

      it 'return 404' do
        expect(response.status).to eq 404
      end

      it 'returns the error key' do
        expect(parsed_response(response)[:errors].first).to eq('record_not_found')
      end
    end
  end

  describe 'GET #index' do
    let(:http_method) { :get }
    let(:action) { :index }

    context 'success' do
      let!(:user1) { FactoryBot.create(:user, :mentor_user) }
      let!(:user2) { FactoryBot.create(:user, :mentor_user) }

      FactoryBot.create(:user, :organization_user)
      FactoryBot.create(:user, :admin_user)

      before do
        send_request(http_method, action, {}, format)
      end

      it 'returns status 200' do
        expect(response.status).to be 200
      end

      it 'returns the information about' do
        expected_response = {
          success: true,
          data: [
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
              facebook: nil,
              linkedin: nil,
              organization: user1.mentor.organization,
              position: user1.mentor.position,
              occupation: user1.mentor.occupation,
              availability: user1.mentor.availability
            },
            {
              id: user2.id,
              email: user2.email,
              role: ['mentor'],
              active: true,
              first_name: user2.mentor.first_name,
              last_name: user2.mentor.last_name,
              phone_number: user2.mentor.phone_number,
              city: user2.mentor.city,
              description: user2.mentor.description,
              skills: user2.mentor.skills.pluck(:name).sort,
              facebook: nil,
              linkedin: nil,
              organization: user2.mentor.organization,
              position: user2.mentor.position,
              occupation: user2.mentor.occupation,
              availability: user2.mentor.availability
            }
          ]
        }
        expect(parsed_response(response).sort).to eql expected_response.sort
      end
    end
  end

  describe 'POST #create' do
    let(:http_method) { :post }
    let(:action) { :create }

    context 'unauthorized' do
      before do
        send_request(http_method, action, {}, format)
      end

      it 'returns 401' do
        expect(response.status).to be(401)
      end

      it 'returns the error key' do
        expect(parsed_response(response)[:errors].first).to eq('unauthorized')
      end
    end

    context 'authorized' do
      before do
        proposal = FactoryBot.create(:proposal)
        proposal.accept
        request.headers['Authorization'] = proposal.auth_token
        user_params = FactoryBot.attributes_for(:user)
        mentor_params = FactoryBot.attributes_for(:mentor)
        user_params.merge!(mentor_params)
        FactoryBot.create(:skill)
        user_params[:skills] = Skill.pluck(:id)
        send_request(http_method, action, user_params, format)
        @expected_response = {
          success: true,
          data:
            {
              email: user_params[:email],
              role: ['mentor'],
              active: true,
              first_name: user_params[:first_name],
              last_name: user_params[:last_name],
              phone_number: user_params[:phone_number],
              city: user_params[:city],
              description: user_params[:description],
              facebook: nil,
              linkedin: nil,
              skills: Skill.pluck(:name),
              organization: user_params[:organization],
              position: user_params[:position],
              occupation: user_params[:occupation],
              availability: user_params[:availability]
            }
        }
      end

      it 'returns 201' do
        expect(response.status).to be(201)
      end

      it 'succesfully creates a mentor' do
        json_response = parsed_response(response)
        json_response[:data] = json_response[:data].except(:id)
        expect(json_response).to eql(@expected_response)
      end

      it 'returns 401 if token is used again' do
        send_request(http_method, action, {}, format)
        expect(response.status).to be(401)
      end

      context 'validation error' do
        before do
          proposal = FactoryBot.create(:proposal)
          proposal.accept
          request.headers['Authorization'] = proposal.auth_token
          allow_any_instance_of(User).to receive(:create).and_return(false)
          send_request(http_method, action, {}, format)
        end

        it 'returns 422' do
          expect(response.status).to be(422)
        end

        it 'returns proper errors' do
          expect(parsed_response(response)).to have_key(:errors)
        end
      end
    end
  end

  describe 'PUT/PATCH #update' do
    let(:http_method) { :put }
    let(:action) { :update }

    context 'success' do
      before do
        user = FactoryBot.create(:user, :mentor_user)
        request.headers['Authorization'] = user.auth_token
        mentor_params = FactoryBot.attributes_for(:mentor)
        mentor_params[:facebook] = 'nelu santinelu'
        mentor_params[:id] = user.id
        mentor_params[:skills] = Skill.last.id.to_s
        request.headers['Authorization'] = user.auth_token
        send_request(http_method, action, mentor_params, format)
        @expected_response = {
          success: true,
          data:
            {
              id: user.id,
              email: user.email,
              role: ['mentor'],
              active: true,
              first_name: mentor_params[:first_name],
              last_name: mentor_params[:last_name],
              phone_number: mentor_params[:phone_number],
              city: mentor_params[:city],
              description: mentor_params[:description],
              skills: Array(Skill.last.name),
              facebook: 'nelu santinelu',
              linkedin: nil,
              organization: mentor_params[:organization],
              position: mentor_params[:position],
              occupation: mentor_params[:occupation],
              availability: mentor_params[:availability]
            }
        }
      end

      it 'returns 200' do
        expect(response.status).to be(200)
      end

      it 'successfully updates a mentor' do
        json_response = parsed_response(response)
        expect(json_response).to eql(@expected_response)
      end
    end

    context 'validation error' do
      before do
        allow_any_instance_of(User).to receive(:update).and_return(false)
        user = FactoryBot.create(:user, :mentor_user)
        request.headers['Authorization'] = user.auth_token
        send_request(http_method, action, { id: user.id }, format)
      end

      it 'returns 422' do
        expect(response.status).to be(422)
      end

      it 'returns proper errors' do
        expect(parsed_response(response)).to have_key(:errors)
      end
    end

    context 'mentor not found' do
      before do
        user = FactoryBot.create(:user, :mentor_user)
        request.headers['Authorization'] = user.auth_token
        send_request(http_method, action, { id: 'invalid_id' }, format)
      end

      it 'return 404' do
        expect(response.status).to eq 404
      end

      it 'returns the error key' do
        expect(parsed_response(response)[:errors].first).to eq('record_not_found')
      end
    end

    context 'forrbiden' do
      before do
        user = FactoryBot.create(:user, :mentor_user)
        request.headers['Authorization'] = user.auth_token
        user = FactoryBot.create(:user, :mentor_user)
        send_request(http_method, action, { id: user.id }, format)
      end

      it 'returns 403' do
        expect(response.status).to eq 403
      end
    end
  end

  describe 'PUT/PATCH activate' do
    let(:http_method) { :put }
    let(:action) { :activate }
    let(:admin) { FactoryBot.create(:user, :admin_user) }
    let!(:user) { FactoryBot.create(:user, :mentor_user, active: false) }
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
    let!(:user) { FactoryBot.create(:user, :mentor_user, active: true) }
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
