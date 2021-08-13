FactoryBot.define do
  factory :pokemon do
    trait :with_details do
      name { 'Bulbasaur' }
    end
  end
end
