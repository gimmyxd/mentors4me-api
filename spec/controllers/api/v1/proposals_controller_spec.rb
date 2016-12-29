describe Api::V1::ProposalsController do
  let(:format) { :json }
  context 'unauthorized' do
    let(:proposal) { FactoryGirl.create(:proposal) }
    before do
      send_request(:get, :show, { id: proposal.id }, format)
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
      user = FactoryGirl.create(:user)
      request.headers['Authorization'] = user.auth_token
    end
    describe 'GET #show' do
      let(:http_method) { :get }
      let(:action) { :show }
      context 'success' do
        let(:proposal) { FactoryGirl.create(:proposal) }
        before(:each) do
          send_request(http_method, action, { id: proposal.id }, format)
        end
        it 'request is successfully made' do
          expect(response.status).to eql(200)
        end

        it 'returns the information about a reporter on a hash' do
          expect(parsed_response(response)[:data][:email]).to eql(proposal.email)
        end
      end

      context 'proposal not found' do
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
        let!(:proposal1) { FactoryGirl.create(:proposal) }
        let!(:proposal2) { FactoryGirl.create(:proposal) }

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
                id: proposal1.id,
                email: proposal1.email,
                description: proposal1.description,
                status: proposal1.status,
                auth_token: proposal1.reload.auth_token
              },
              {
                id: proposal2.id,
                email: proposal2.email,
                description: proposal2.description,
                status: proposal2.status,
                auth_token: proposal2.reload.auth_token
              }
            ]
          }
          expect(parsed_response(response).sort).to eql expected_response.sort
        end
      end

      context 'filters validations' do
        before do
          send_request(http_method, action, { status: 'invalid' }, format)
        end
        it 'returns 422 if status is not in list' do
          expect(response.status).to eql(422)
        end

        it 'returns the error key' do
          expect(parsed_response(response)[:errors]).to eq(['status.not_in_list'])
        end
      end
    end

    describe 'POST #create' do
      let(:http_method) { :post }
      let(:action) { :create }
      before do
        proposal_params = FactoryGirl.attributes_for(:proposal)
        send_request(http_method, action, proposal_params, format)
        @expected_response = {
          success: true,
          data:
            {
              email: proposal_params[:email],
              description: proposal_params[:description],
              status: proposal_params[:status],
              auth_token: proposal_params[:auth_token]
            }
        }
      end

      it 'returns 201' do
        expect(response.status).to eql(201)
      end

      it 'succesfully creates a proposal' do
        json_response = parsed_response(response)
        json_response[:data] = json_response[:data].except(:id)
        expect(json_response).to eql(@expected_response)
      end

      context 'validation error' do
        before do
          allow_any_instance_of(Proposal).to receive(:create).and_return(false)
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

    describe 'POST #accept' do
      let(:http_method) { :post }
      let(:action) { :accept }
      let!(:proposal) { FactoryGirl.create(:proposal) }

      context 'success' do
        it 'returns 200' do
          send_request(http_method, action, { id: proposal.id }, format)
          expect(response.status).to eq(200)
        end

        it 'calls send_invitation_email' do
          expect(subject).to receive(:send_invitation_email)
          send_request(http_method, action, { id: proposal.id }, format)
        end
      end

      it 'returns false if proposal is allready accepted' do
        proposal.accept
        expect(subject).not_to receive(:send_invitation_email)
        send_request(http_method, action, { id: proposal.id }, format)
      end

      context 'validation error' do
        before do
          allow_any_instance_of(Proposal).to receive(:accept).and_return(false)
          send_request(http_method, action, { id: proposal.id }, format)
        end
        it 'returns 422' do
          expect(response.status).to eql(422)
        end

        it 'returns proper errors' do
          expect(parsed_response(response)).to have_key(:errors)
        end
      end
    end

    describe 'POST #reject' do
      let(:http_method) { :post }
      let(:action) { :reject }
      let!(:proposal) { FactoryGirl.create(:proposal) }

      context 'success' do
        it 'returns 200' do
          send_request(http_method, action, { id: proposal.id }, format)
          expect(response.status).to eq(200)
        end

        it 'calls send_rejection_email' do
          expect(subject).to receive(:send_rejection_email)
          send_request(http_method, action, { id: proposal.id }, format)
        end
      end

      it 'returns false if proposal is allready accepted' do
        proposal.accept
        expect(subject).not_to receive(:send_rejection_email)
        send_request(http_method, action, { id: proposal.id }, format)
      end

      context 'validation error' do
        before do
          allow_any_instance_of(Proposal).to receive(:reject).and_return(false)
          send_request(http_method, action, { id: proposal.id }, format)
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
end
