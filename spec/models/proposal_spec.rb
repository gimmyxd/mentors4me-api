RSpec.describe Proposal, type: :model do
  context 'fields' do
    it { is_expected.to respond_to(:email) }
    it { is_expected.to respond_to(:description) }
    it { is_expected.to respond_to(:status) }
    it { is_expected.to respond_to(:auth_token) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_length_of(:description).is_at_most(500) }
    it { is_expected.to validate_uniqueness_of(:auth_token) }
  end
end
