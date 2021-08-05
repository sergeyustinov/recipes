require 'rails_helper'

RSpec.describe Recipe, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to have_one(:action_text_rich_text).class_name('ActionText::RichText') }
  end

  describe 'action texts' do
    it { should have_rich_text(:content) }
  end

  describe 'enums' do
    it 'sets for status' do
      is_expected.to define_enum_for(:status)
        .with_values(Recipe::STATUSES.each_with_object(h = {}) { |s, h| h[s] = s })
        .backed_by_column_of_type(:string)
    end

    it 'sets default value for status' do
      expect(described_class.new.status).to eq Recipe::STATUSES.first
    end
  end

  describe 'validation' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:status) }
  end

  describe '.of_owner' do
    let(:user) { create :user }
    let!(:recipe_of_user) { create :recipe, user: user }
    let!(:other_recipe) { create :recipe }

    subject { described_class.of_owner(user) }

    it { is_expected.to include(recipe_of_user) }
    it { is_expected.not_to include(other_recipe) }
  end

  describe '.ordered' do
    let!(:first_recipe) { create :recipe }
    let!(:second_recipe) { create :recipe }
    let!(:third_recipe) { create :recipe }

    subject { described_class.ordered }

    it 'returns first recipe that created last' do
      expect(subject.first).to eq(third_recipe)
    end

    it 'returns last recipe that created first' do
      expect(subject.last).to eq(first_recipe)
    end

    it { is_expected.to include(second_recipe) }
  end

  describe '.recent' do
    let!(:first_recipe) { create :recipe }
    let!(:second_recipe) { create :recipe }
    let!(:third_recipe) { create :recipe }
    let!(:fourth_recipe) { create :recipe }
    let!(:fifth_recipe) { create :recipe }

    let(:kount) { 2 }
    let(:after_id) { second_recipe.id }

    subject { described_class.recent(after_id, kount) }

    before do
      allow(described_class).to receive(:ordered).and_return(described_class.ordered)
    end

    it 'orderes records by created at' do
      expect(described_class).to receive(:ordered)

      subject
    end

    it { is_expected.not_to include(first_recipe) }
    it { is_expected.not_to include(second_recipe) }
    it { is_expected.not_to include(third_recipe) } # as we limitted count to 2 and this one is oldest from 3
    it { is_expected.to include(fourth_recipe) }
    it { is_expected.to include(fifth_recipe) }
  end

  describe '.search' do
    let!(:recipe_with_query_in_title) { create :recipe, title: "title of recipe with #{query}.. and some end of text" }
    let!(:recipe_with_query_in_content) { create :recipe, content: "content of recipe with #{query}.. here end of text" }
    let!(:recipe_without_query) { create :recipe }

    let(:query) { 'QUERY_HERE' }

    subject { described_class.search query}

    context 'when query sent' do
      it { is_expected.to include(recipe_with_query_in_title) }
      it { is_expected.to include(recipe_with_query_in_content) }
      it { is_expected.not_to include(recipe_without_query) }
    end

    context 'when query did not send' do
      let(:query) { nil }

      it { is_expected.to include(recipe_with_query_in_title) }
      it { is_expected.to include(recipe_with_query_in_content) }
      it { is_expected.to include(recipe_without_query) }
    end
  end
end
