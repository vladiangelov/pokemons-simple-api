FactoryBot.define do
  factory :pokemon_type do
    association :pokemon
    association :type
  end
end
