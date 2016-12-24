require 'rails_helper'

RSpec.describe Profile, type: :model do
  context 'fields' do
    before { @profile = FactoryGirl.build(:profile) }

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
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:skills) }
    it { is_expected.to have_many(:skill_assignments) }
  end
end
