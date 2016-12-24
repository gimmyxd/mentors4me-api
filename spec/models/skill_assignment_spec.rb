RSpec.describe SkillAssignment, type: :model do
  context 'fields' do
    it { is_expected.to belong_to(:profile) }
    it { is_expected.to belong_to(:skill) }
  end
end
