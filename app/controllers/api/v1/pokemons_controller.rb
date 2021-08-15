##
# This is the main controller of the API, which serves an index of pokemons and a show page of a single pokemon
#
class Api::V1::PokemonsController < ApplicationController
  before_action :assign_pagination_values, only: [:index]
  before_action :check_for_incompatible_pagination_values, only: [:index]

  def index
    pokemon_list = Pokemon.paginated_with_types(@page, @limit).map do |pokemon|
      decorate_pokemon(pokemon)
    end

    has_next_page = Pokemon.page(@page).per(@limit).next_page.present?

    render json: { total_count: Pokemon.count, next_page: has_next_page, pokemon: pokemon_list, success: true }, status: :ok
  end

  private

  def decorate_pokemon(pokemon)
    {
      id: pokemon.id,
      name: pokemon.name,
      types: create_array_of_types(pokemon)
    }
  end

  def create_array_of_types(pokemon)
    pokemon.pokemon_types.map do |pokemon_type|
      { name: pokemon_type.type.name }
    end
  end

  def check_for_incompatible_pagination_values
    render json: { error: 'Offset should be divisible by limit (limit is 20, if not supplied)', success: false }, status: :bad_request and return if @offset.positive? && (@offset % @limit).positive?

    render json: { error: 'Maximum 100 items on a page', success: false }, status: :bad_request and return if @limit > 100
  end

  def assign_pagination_values
    @offset = pagination_offset
    @limit = pagination_limit
    @page = current_page(@offset, @limit)
  end

  def pagination_offset
    if params[:offset] && params[:offset].to_i != 0
      params[:offset].to_i
    else
      0
    end
  end

  def pagination_limit
    if params[:limit] && params[:limit].to_i != 0
      params[:limit].to_i
    else
      20
    end
  end

  def current_page(offset, limit)
    if offset.zero?
      1
    else
      (offset / limit) + 1
    end
  end
end
