require 'rails_helper'

RSpec.describe User, type: :model do
  context 'fields' do
    before { @user = FactoryGirl.build(:user) }

    it { is_expected.to respond_to(:email) }
    it { is_expected.to respond_to(:password) }
    it { is_expected.to respond_to(:password_confirmation) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_presence_of(:password_confirmation) }
    it { is_expected.to have_one(:profile) }
    it { is_expected.to have_one(:organization) }
  end
end
