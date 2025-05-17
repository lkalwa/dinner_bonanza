FactoryBot.define do
  factory :ingredient do
    sequence(:content) { |n| "Ingredient #{n}" }
    association :recipe
  end
end
