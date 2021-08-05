admin = User.admin.create first_name: 'Admin', email: 'admin@recipe.com', password: 'admin@recipe.com'
user = User.simple.create first_name: 'Simple User', email: 'user@recipe.com', password: 'user@recipe.com'
user2 = User.simple.create first_name: 'Simple User 2', email: 'user2@recipe.com', password: 'user2@recipe.com'

10.times do |time|
  Recipe.create title: Faker::Food.dish, content: Faker::Food.description, user: [user, user2].sample
end
