RSpec.describe Context, type: :model do
  context 'fields' do
    it { is_expected.to respond_to(:description) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to belong_to(:mentor) }
    it { is_expected.to belong_to(:organization) }
  end
end
