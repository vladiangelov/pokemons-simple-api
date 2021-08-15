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

  def to_show_api_format
    to_index_api_format.merge(additional_details_for_show)
  end

  private

  def additional_details_for_show
    {
      poke_api_id: object.poke_api_id,
      base_experience: object.base_experience,
      height: object.height,
      is_default: object.is_default,
      order: object.order,
      weight: object.weight
    }
  end

  def create_array_of_types(object)
    object.pokemon_types.map do |pokemon_type|
      { name: pokemon_type.type.name }
    end
  end
end
