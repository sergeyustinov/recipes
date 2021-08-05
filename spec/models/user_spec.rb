require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'enums' do
    it 'sets for role' do
      is_expected.to define_enum_for(:role)
        .with_values(User::ROLES.each_with_object(h = {}) { |s, h| h[s] = s })
        .backed_by_column_of_type(:string)
    end

    it 'sets default value for role' do
      expect(described_class.new.role).to eq User::ROLES.first
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:recipes).dependent(:destroy) }
  end

  describe 'validation' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:role) }
  end

  def owner_of?(inst)
    inst.respond_to?(:user_id) && inst.user_id == id
  end

  describe '#owner_of?' do
    let(:user) { create :user }
    let(:inst) { nil }

    subject { user.owner_of?(inst) }

    context 'when sent instance of user' do
      let(:inst) { create :recipe, user: user }

      it { is_expected.to be_truthy }
    end

    context 'when sent instance not of user' do
      let(:inst) { create :recipe }

      it { is_expected.to be_falsey }
    end

    context 'when sent instance that could not be linked to user' do
      let(:inst) { build :user }

      it { is_expected.to be_falsey }
    end
  end
end
