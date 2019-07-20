# frozen_string_literal: true
describe Api::V1::ProposalsController do
  let(:format) { :json }
  context 'unauthorized' do
    let(:proposal) { FactoryBot.create(:proposal) }
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
      user = FactoryBot.create(:user)
      request.headers['Authorization'] = user.auth_token
    end
    describe 'GET #show' do
      let(:http_method) { :get }
      let(:action) { :show }
      context 'success' do
        let(:proposal) { FactoryBot.create(:proposal) }
        before(:each) do
          send_request(http_method, action, { id: proposal.id }, format)
        end
        it 'request is successfully made' do
          expect(response.status).to eql(200)
        end

        it 'returns the information about a reporter on a hash' do
          expect(parsed_response(response)[:data][:mentor_email]).to eql(proposal.mentor_email)
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
        let!(:proposal1) { FactoryBot.create(:proposal) }
        let!(:proposal2) { FactoryBot.create(:proposal) }

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
                proposer_first_name: proposal1.proposer_first_name,
                proposer_last_name: proposal1.proposer_last_name,
                proposer_email: proposal1.proposer_email,
                proposer_phone_number: proposal1.proposer_phone_number,
                mentor_first_name: proposal1.mentor_first_name,
                mentor_last_name: proposal1.mentor_last_name,
                mentor_organization: proposal1.mentor_organization,
                mentor_email: proposal1.mentor_email,
                mentor_phone_number: proposal1.mentor_phone_number,
                mentor_facebook: proposal1.mentor_facebook,
                mentor_linkedin: proposal1.mentor_linkedin,
                reason: proposal1.reason,
                auth_token: proposal1.reload.auth_token
              },
              {
                id: proposal2.id,
                proposer_first_name: proposal2.proposer_first_name,
                proposer_last_name: proposal2.proposer_last_name,
                proposer_email: proposal2.proposer_email,
                proposer_phone_number: proposal2.proposer_phone_number,
                mentor_first_name: proposal2.mentor_first_name,
                mentor_last_name: proposal2.mentor_last_name,
                mentor_organization: proposal2.mentor_organization,
                mentor_email: proposal2.mentor_email,
                mentor_phone_number: proposal2.mentor_phone_number,
                mentor_facebook: proposal2.mentor_facebook,
                mentor_linkedin: proposal2.mentor_linkedin,
                reason: proposal2.reason,
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

      context 'success' do
        before(:each) do
          stub_request(:post, 'https://api.sendgrid.com/v3/mail/send')
            .to_return(status: 200, body: '', headers: {})
          @proposal_params = FactoryBot.attributes_for(:proposal)
          @expected_response = {
            success: true,
            data:
              {
                proposer_first_name: @proposal_params[:proposer_first_name],
                proposer_last_name: @proposal_params[:proposer_last_name],
                proposer_email: @proposal_params[:proposer_email],
                proposer_phone_number: @proposal_params[:proposer_phone_number],
                mentor_first_name: @proposal_params[:mentor_first_name],
                mentor_last_name: @proposal_params[:mentor_last_name],
                mentor_organization: @proposal_params[:mentor_organization],
                mentor_email: @proposal_params[:mentor_email],
                mentor_phone_number: @proposal_params[:mentor_phone_number],
                mentor_facebook: @proposal_params[:mentor_facebook],
                mentor_linkedin: @proposal_params[:mentor_linkedin],
                reason: @proposal_params[:reason],
                auth_token: @proposal_params[:auth_token]
              }
          }
        end

        it 'returns 201' do
          send_request(http_method, action, @proposal_params, format)
          expect(response.status).to eql(201)
        end

        it 'succesfully creates a proposal' do
          send_request(http_method, action, @proposal_params, format)
          json_response = parsed_response(response)
          json_response[:data] = json_response[:data].except(:id)
          expect(json_response).to eql(@expected_response)
        end

        it 'succesfully sends email to proposer' do
          expect(ProposalsMailer).to receive(:send_confirmation)
          @proposal_params = FactoryBot.attributes_for(:proposal)
          send_request(http_method, action, @proposal_params, format)
        end
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

        it 'does not send email' do
          expect(ProposalsMailer).not_to receive(:send_confirmation)
          send_request(http_method, action, {}, format)
        end
      end
    end

    describe 'POST #accept' do
      let(:http_method) { :post }
      let(:action) { :accept }
      let!(:proposal) { FactoryBot.create(:proposal) }

      context 'success' do
        it 'returns 200' do
          send_request(http_method, action, { id: proposal.id }, format)
          expect(response.status).to eq(200)
        end

        it 'calls send_invitation_mentor_email' do
          expect(InvitationsMailer).to receive(:send_invitation)
          send_request(http_method, action, { id: proposal.id }, format)
        end
      end

      it 'returns false if proposal is allready accepted' do
        proposal.accept
        expect(InvitationsMailer).not_to receive(:send_invitation)
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
      let!(:proposal) { FactoryBot.create(:proposal) }

      context 'success' do
        it 'returns 200' do
          send_request(http_method, action, { id: proposal.id }, format)
          expect(response.status).to eq(200)
        end
      end

      it 'returns false if proposal is allready accepted' do
        proposal.accept
        expect(subject).not_to receive(:send_rejection_mentor_email)
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
