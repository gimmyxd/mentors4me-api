RSpec.describe Skill, type: :model do
  context 'fields' do
    it { is_expected.to respond_to(:name) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(100) }
    it { is_expected.to have_many(:mentors) }
    it { is_expected.to have_many(:skill_assignments) }
  end
end
