# frozen_string_literal: true

RSpec.describe SkillAssignment, type: :model do
  context 'fields' do
    it { is_expected.to belong_to(:mentor) }
    it { is_expected.to belong_to(:skill) }
  end
end
