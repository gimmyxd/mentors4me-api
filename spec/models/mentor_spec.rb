# frozen_string_literal: true
RSpec.describe Mentor, type: :model do
  context 'fields' do
    it { is_expected.to respond_to(:first_name) }
    it { is_expected.to respond_to(:last_name) }
    it { is_expected.to respond_to(:phone_number) }
    it { is_expected.to respond_to(:city) }
    it { is_expected.to respond_to(:description) }
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:phone_number) }
    it { is_expected.to validate_presence_of(:city) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_length_of(:first_name).is_at_most(50) }
    it { is_expected.to validate_length_of(:last_name).is_at_most(50) }
    it { is_expected.to validate_length_of(:phone_number).is_at_most(50) }
    it { is_expected.to validate_length_of(:city).is_at_most(50) }
    it { is_expected.to validate_length_of(:description).is_at_most(500) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:skills) }
    it { is_expected.to have_many(:skill_assignments) }
  end
end
