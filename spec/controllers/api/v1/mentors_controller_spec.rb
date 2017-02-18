describe Api::V1::MentorsController do
  let(:format) { :json }

  describe 'GET #show' do
    let(:http_method) { :get }
    let(:action) { :show }
    context 'success' do
      let(:mentor) { FactoryGirl.create(:user, :mentor_user) }
      before(:each) do
        send_request(http_method, action, { id: mentor.id }, format)
      end
      it 'request is successfully made' do
        expect(response.status).to eql(200)
      end

      it 'returns the information about a reporter on a hash' do
        expect(parsed_response(response)[:data][:email]).to eql(mentor.email)
      end
    end

    context 'mentor not found' do
      before(:each) do
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
      let!(:user1) { FactoryGirl.create(:user, :mentor_user) }
      let!(:user2) { FactoryGirl.create(:user, :mentor_user) }
      FactoryGirl.create(:user, :organization_user)
      FactoryGirl.create(:user, :admin_user)

      before do
        send_request(http_method, action, {}, format)
      end

      it 'returns status 200' do
        expect(response.status).to eql 200
      end

      it 'returns the information about' do
        expected_response = {
          success: true,
          data: [
            {
              id: user1.id,
              email: user1.email,
              role: ['mentor'],
              first_name: user1.mentor.first_name,
              last_name: user1.mentor.last_name,
              phone_number: user1.mentor.phone_number,
              city: user1.mentor.city,
              description: user1.mentor.description,
              skills: user1.mentor.skills.pluck(:name).sort,
              facebook: nil,
              linkedin: nil
            },
            {
              id: user2.id,
              email: user2.email,
              role: ['mentor'],
              first_name: user2.mentor.first_name,
              last_name: user2.mentor.last_name,
              phone_number: user2.mentor.phone_number,
              city: user2.mentor.city,
              description: user2.mentor.description,
              skills: user2.mentor.skills.pluck(:name).sort,
              facebook: nil,
              linkedin: nil
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

    before do
      stub_request(:post, 'https://api.sendgrid.com/v3/mail/send')
        .to_return(status: 200, body: '', headers: {})
    end

    context 'unauthorized' do
      before do
        send_request(http_method, action, {}, format)
      end
      it 'returns 401' do
        expect(response.status).to eql(401)
      end

      it 'returns the error key' do
        expect(parsed_response(response)[:errors].first).to eq('unauthorized')
      end
    end

    context 'authorized' do
      before do
        proposal = FactoryGirl.create(:proposal)
        proposal.accept
        request.headers['Authorization'] = proposal.auth_token
        user_params = FactoryGirl.attributes_for(:user)
        mentor_params = FactoryGirl.attributes_for(:mentor)
        user_params.merge!(mentor_params)
        FactoryGirl.create(:skill)
        user_params[:skills] = Skill.pluck(:id)
        send_request(http_method, action, user_params, format)
        @expected_response = {
          success: true,
          data:
            {
              email: user_params[:email],
              role: ['mentor'],
              first_name: user_params[:first_name],
              last_name: user_params[:last_name],
              phone_number: user_params[:phone_number],
              city: user_params[:city],
              description: user_params[:description],
              facebook: nil,
              linkedin: nil,
              skills: Skill.pluck(:name)
            }
        }
      end

      it 'returns 201' do
        expect(response.status).to eql(201)
      end

      it 'succesfully creates a mentor' do
        json_response = parsed_response(response)
        json_response[:data] = json_response[:data].except(:id)
        expect(json_response).to eql(@expected_response)
      end

      it 'returns 401 if token is used again' do
        send_request(http_method, action, {}, format)
        expect(response.status).to eql(401)
      end

      context 'validation error' do
        before do
          proposal = FactoryGirl.create(:proposal)
          proposal.accept
          request.headers['Authorization'] = proposal.auth_token
          allow_any_instance_of(User).to receive(:create).and_return(false)
          send_request(http_method, action, {}, format)
        end
        it 'returns 422' do
          expect(response.status).to eql(422)
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
        user = FactoryGirl.create(:user, :mentor_user)
        request.headers['Authorization'] = user.auth_token
        mentor_params = FactoryGirl.attributes_for(:mentor)
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
              first_name: mentor_params[:first_name],
              last_name: mentor_params[:last_name],
              phone_number: mentor_params[:phone_number],
              city: mentor_params[:city],
              description: mentor_params[:description],
              skills: Array(Skill.last.name),
              facebook: 'nelu santinelu',
              linkedin: nil
            }
        }
      end

      it 'returns 200' do
        expect(response.status).to eql(200)
      end

      it 'successfully updates a mentor' do
        json_response = parsed_response(response)
        expect(json_response).to eql(@expected_response)
      end
    end

    context 'validation error' do
      before do
        allow_any_instance_of(User).to receive(:update).and_return(false)
        user = FactoryGirl.create(:user, :mentor_user)
        request.headers['Authorization'] = user.auth_token
        send_request(http_method, action, { id: user.id }, format)
      end
      it 'returns 422' do
        expect(response.status).to eql(422)
      end

      it 'returns proper errors' do
        expect(parsed_response(response)).to have_key(:errors)
      end
    end

    context 'mentor not found' do
      before(:each) do
        user = FactoryGirl.create(:user, :mentor_user)
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
        user = FactoryGirl.create(:user, :mentor_user)
        request.headers['Authorization'] = user.auth_token
        user = FactoryGirl.create(:user, :mentor_user)
        send_request(http_method, action, { id: user.id }, format)
      end

      it 'returns 403' do
        expect(response.status).to eq 403
      end
    end
  end

  describe '#DELETE destroy' do
    let(:http_method) { :delete }
    let(:action) { :destroy }
    context 'successful deletion' do
      let(:user) { FactoryGirl.create(:user, :mentor_user) }
      before do
        request.headers['Authorization'] = user.auth_token
        send_request(:delete, :destroy, { id: user.id }, format)
      end
      it 'response status is 201' do
        expect(response.status).to eql 201
      end

      it 'deactivates user' do
        expect(user.reload.active).to eq(false)
      end
    end

    context 'validation error' do
      before do
        allow_any_instance_of(User).to receive(:save).and_return(false)
        user = FactoryGirl.create(:user, :mentor_user)
        request.headers['Authorization'] = user.auth_token
        send_request(http_method, action, { id: user.id }, format)
      end
      it 'returns 422' do
        expect(response.status).to eql(422)
      end

      it 'returns proper errors' do
        expect(parsed_response(response)).to have_key(:errors)
      end
    end

    context 'mentor not found' do
      before(:each) do
        user = FactoryGirl.create(:user, :mentor_user)
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
        user = FactoryGirl.create(:user, :mentor_user)
        request.headers['Authorization'] = user.auth_token
        user = FactoryGirl.create(:user, :mentor_user)
        send_request(http_method, action, { id: user.id }, format)
      end

      it 'returns 403' do
        expect(response.status).to eq 403
      end
    end
  end
end
