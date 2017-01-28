RSpec.describe Context, type: :model do
  context 'fields' do
    it { is_expected.to respond_to(:description) }
    it { is_expected.to respond_to(:mentor_id) }
    it { is_expected.to respond_to(:organization_id) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_length_of(:description).is_at_most(500) }
    it { is_expected.to belong_to(:mentor) }
    it { is_expected.to belong_to(:organization) }
    it { is_expected.to have_many(:messages) }
  end
end
