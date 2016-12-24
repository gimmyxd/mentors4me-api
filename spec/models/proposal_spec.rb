RSpec.describe Proposal, type: :model do
  context 'fields' do
    it { is_expected.to respond_to(:email) }
    it { is_expected.to respond_to(:description) }
    it { is_expected.to respond_to(:status) }
    it { is_expected.to respond_to(:invitation_token) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_uniqueness_of(:invitation_token) }
  end
end
