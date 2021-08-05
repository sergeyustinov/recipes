require 'rails_helper'

RSpec.describe RecipePolicy, type: :policy do
  
  let(:recipe) { create :recipe }

  subject { described_class.new(user, recipe) }

  context 'when user is visitor' do
    let(:user) { nil }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to forbid_action(:new) }
    it { is_expected.to forbid_action(:create) }
    it { is_expected.to forbid_action(:edit) }
    it { is_expected.to forbid_action(:update) }
    it { is_expected.to forbid_action(:destroy) }
  end

  context 'when user signed in' do
    let(:user) { create :user, role: 'simple' }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:new) }
    it { is_expected.to permit_action(:create) }

    context 'when user is author of recipe' do
      let(:recipe) { create :recipe, user: user }

      it { is_expected.to permit_action(:edit) }
      it { is_expected.to permit_action(:update) }
      it { is_expected.to permit_action(:destroy) }
    end

    context 'when user is not author of recipe but admin' do
      let(:user) { create :user, role: 'admin' }

      it { is_expected.to permit_action(:edit) }
      it { is_expected.to permit_action(:update) }
      it { is_expected.to permit_action(:destroy) }
    end

    context 'when user is not author of recipe' do
      it { is_expected.to forbid_action(:edit) }
      it { is_expected.to forbid_action(:update) }
      it { is_expected.to forbid_action(:destroy) }
    end
  end
end
