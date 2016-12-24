RSpec.describe Role, type: :model do
  context 'fields' do
    it { is_expected.to respond_to(:slug) }
    it { is_expected.to respond_to(:description) }
    it { is_expected.to validate_presence_of(:slug) }
    it { is_expected.to validate_uniqueness_of(:slug) }
    it { is_expected.to have_many(:users) }
    it { is_expected.to have_many(:role_assignments) }
  end
end
