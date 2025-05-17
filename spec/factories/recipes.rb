FactoryBot.define do
  factory :recipe do
    sequence(:title) { |n| "Recipe #{n}" }
    cook_time { rand(30..120) }
    prep_time { rand(15..60) }
    rating { rand(0.0..5.0).round(1) }
    image_url { "https://example.com/image#{rand(1..100)}.jpg" }

    trait :with_ingredients do
      after(:create) do |recipe|
        create_list(:ingredient, rand(3..8), recipe: recipe)
      end
    end

    trait :with_specific_ingredient do
      after(:create) do |recipe|
        create(:ingredient, recipe: recipe, content: "specific ingredient")
      end
    end
  end
end
