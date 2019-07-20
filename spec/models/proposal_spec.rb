# frozen_string_literal: true
describe Proposal, type: :model do
  context 'fields' do
    it { is_expected.to respond_to(:proposer_first_name) }
    it { is_expected.to respond_to(:proposer_last_name) }
    it { is_expected.to respond_to(:proposer_email) }
    it { is_expected.to respond_to(:proposer_phone_number) }
    it { is_expected.to respond_to(:mentor_first_name) }
    it { is_expected.to respond_to(:mentor_last_name) }
    it { is_expected.to respond_to(:mentor_organization) }
    it { is_expected.to respond_to(:mentor_email) }
    it { is_expected.to respond_to(:mentor_phone_number) }
    it { is_expected.to respond_to(:mentor_facebook) }
    it { is_expected.to respond_to(:mentor_linkedin) }
    it { is_expected.to respond_to(:reason) }
    it { is_expected.to respond_to(:status) }
    it { is_expected.to validate_presence_of(:proposer_first_name) }
    it { is_expected.to validate_presence_of(:proposer_last_name) }
    it { is_expected.to validate_presence_of(:proposer_email) }
    it { is_expected.to validate_presence_of(:proposer_phone_number) }
    it { is_expected.to validate_presence_of(:mentor_first_name) }
    it { is_expected.to validate_presence_of(:mentor_last_name) }
    it { is_expected.to validate_presence_of(:mentor_organization) }
    it { is_expected.to validate_presence_of(:mentor_email) }
    it { is_expected.to validate_presence_of(:mentor_phone_number) }
    it { is_expected.to validate_presence_of(:reason) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_length_of(:reason).is_at_most(500) }
    it { is_expected.to validate_uniqueness_of(:auth_token) }
    it { is_expected.to validate_uniqueness_of(:mentor_email) }
  end

  context 'validations' do
    context 'uniqueness of proposed user' do
      let!(:proposal1) { FactoryBot.create(:proposal, mentor_email: 'test@example.com') }
      let!(:proposal2) { FactoryBot.build(:proposal, mentor_email: 'test@example.com') }

      it 'returns valid for unique user' do
        expect(proposal1).to be_valid
      end

      it 'returns email validation error for used email' do
        expect(proposal2).not_to be_valid
        expect(proposal2.errors.details[:mentor_email].first).to eql(error: :taken, value: 'test@example.com')
      end
    end
  end

  context 'scopes' do
    let!(:pending_proposals) { FactoryBot.create_list(:proposal, 3, status: CP::PENDING) }
    let!(:accepted_proposals) { FactoryBot.create_list(:proposal, 4, status: CP::ACCEPTED) }
    let!(:rejected_proposals) { FactoryBot.create_list(:proposal, 5, status: CP::REJECTED) }

    it 'returns the pending proposals' do
      expect(Proposal.status(CP::PENDING).sort).to eql(pending_proposals.sort)
    end

    it 'returns the accepted proposals' do
      expect(Proposal.status(CP::ACCEPTED).sort).to eql(accepted_proposals.sort)
    end

    it 'returns the rejected proposals' do
      expect(Proposal.status(CP::REJECTED).sort).to eql(rejected_proposals.sort)
    end
  end

  context 'instance methods' do
    let!(:pending_proposal) { FactoryBot.create(:proposal, status: CP::PENDING) }
    let!(:accepted_proposal) { FactoryBot.create(:proposal, status: CP::ACCEPTED) }
    let!(:rejected_proposal) { FactoryBot.create(:proposal, status: CP::REJECTED) }
    context 'accept' do
      it 'returns false for already accepted proposal' do
        expect(accepted_proposal.accept).to eq(false)
      end

      it 'returns false for already rejected proposal' do
        expect(rejected_proposal.accept).to eq(false)
      end

      it 'returns change the status of pending proposal to accepted' do
        pending_proposal.accept
        expect(pending_proposal.reload.status).to eq(CP::ACCEPTED)
      end
    end

    context 'reject' do
      it 'returns false for already accepted proposal' do
        expect(accepted_proposal.accept).to eq(false)
      end

      it 'returns false for already rejected proposal' do
        expect(rejected_proposal.accept).to eq(false)
      end

      it 'returns change the status of pending proposal to accepted' do
        pending_proposal.reject
        expect(pending_proposal.reload.status).to eq(CP::REJECTED)
      end
    end

    context 'pending' do
      it 'sets status of proposal to pending' do
        accepted_proposal.pending
        accepted_proposal.save
        expect(accepted_proposal.reload.status).to eq(CP::PENDING)
      end
    end

    context 'pending?' do
      it 'returns false accepted proposal' do
        expect(accepted_proposal.pending?).to eq(false)
      end

      it 'returns false for rejected proposal' do
        expect(rejected_proposal.pending?).to eq(false)
      end

      it 'returns true for pending proposal' do
        expect(pending_proposal.pending?).to eq(true)
      end
    end

    context 'accepted?' do
      it 'returns false pending proposal' do
        expect(pending_proposal.accepted?).to eq(false)
      end

      it 'returns false for rejected proposal' do
        expect(rejected_proposal.accepted?).to eq(false)
      end

      it 'returns true for accepted proposal' do
        expect(accepted_proposal.accepted?).to eq(true)
      end
    end

    context 'rejected?' do
      it 'returns false accepted proposal' do
        expect(accepted_proposal.rejected?).to eq(false)
      end

      it 'returns false for pending proposal' do
        expect(pending_proposal.rejected?).to eq(false)
      end

      it 'returns true for rejected proposal' do
        expect(rejected_proposal.rejected?).to eq(true)
      end
    end
  end
end
