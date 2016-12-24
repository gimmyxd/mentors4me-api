RSpec.describe RoleAssignment, type: :model do
  context 'fields' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:role) }
  end
end
