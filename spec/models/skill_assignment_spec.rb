require 'rails_helper'

RSpec.describe SkillAssignment, type: :model do
  context 'fields' do
    before { @skill_assignment = FactoryGirl.build(:skill_assignment) }
    it { is_expected.to belong_to(:profile) }
    it { is_expected.to belong_to(:skill) }
  end
end
