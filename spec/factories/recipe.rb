FactoryBot.define do
  factory :recipe do
    title { Faker::Food.dish }
    content { Faker::Food.description }
    user { create :user }
  end
end
