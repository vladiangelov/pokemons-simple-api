class Pokemon < ApplicationRecord
  has_many :pokemon_types

  scope :paginated_with_types, ->(page, limit) { includes(pokemon_types: :type).page(page).per(limit).order(:id) }
end
