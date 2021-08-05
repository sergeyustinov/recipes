json.items do
  json.array! @recipes.each_with_index.to_a do |recipe, index|
    json.html  render(partial: 'recipe', locals: { recipe: recipe, index: index }, formats: [:html], handlers: [:haml])
    json.id recipe.id
    json.index index
  end
end
