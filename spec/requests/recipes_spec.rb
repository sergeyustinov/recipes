require 'rails_helper'
# @todo
RSpec.describe "Recipes", type: :request do
  describe "GET /recipes" do
    let(:recipes) { Recipe.all }
    let(:dbl) { double }

    subject { get recipes_path }

    before do
      create_list :recipe, 1

      allow(Recipe).to receive_message_chain(:ordered, :with_rich_text_content_and_embeds).and_return dbl
      allow(dbl).to receive_message_chain(:search).and_return recipes
    end

    it 'renders succesfully' do
      subject
      expect(response).to have_http_status(200)
    end

    it 'assignes @recipes' do
      subject
      expect(assigns(:recipes).to_a).to eq(recipes.to_a)
    end
  end
end
