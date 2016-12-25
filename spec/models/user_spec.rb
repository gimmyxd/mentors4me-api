RSpec.describe User, type: :model do
  context 'fields' do
    it { is_expected.to respond_to(:email) }
    it { is_expected.to respond_to(:password) }
    it { is_expected.to respond_to(:password_confirmation) }
    it { is_expected.to respond_to(:role_id) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_presence_of(:password_confirmation) }
    it { is_expected.to have_one(:mentor) }
    it { is_expected.to have_one(:organization) }
    it { is_expected.to have_many(:roles) }
    it { is_expected.to have_many(:role_assignments) }
  end
end
