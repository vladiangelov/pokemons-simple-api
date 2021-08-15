##
# Decorates pokemons with the expected format for the API responses
#
class Api::V1::PokemonDecorator < ApplicationDecorator
  delegate_all

  def to_index_api_format
    {
      id: object.id,
      name: object.name,
      types: create_array_of_types(object)
    }
  end

  private

  def create_array_of_types(object)
    object.pokemon_types.map do |pokemon_type|
      { name: pokemon_type.type.name }
    end
  end
end
