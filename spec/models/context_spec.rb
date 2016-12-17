require 'rails_helper'

RSpec.describe Context, type: :model do
  context 'fields' do
    before { @context = FactoryGirl.build(:context) }

    it { is_expected.to respond_to(:description) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to belong_to(:profile) }
    it { is_expected.to belong_to(:organization) }
  end
end
