##
# This is the main controller of the API, which serves an index of pokemons and a show page of a single pokemon
#
class Api::V1::PokemonsController < ApplicationController
  before_action :assign_pagination_values, only: [:index]
  before_action :check_for_incompatible_pagination_values, only: [:index]

  def index
    pokemon_list = Pokemon.paginated_with_types(@page, @limit).map do |pokemon|
      Api::V1::PokemonDecorator.decorate(pokemon).to_index_api_format
    end

    has_next_page = Pokemon.page(@page).per(@limit).next_page.present?

    render json: { total_count: Pokemon.count, next_page: has_next_page, pokemon: pokemon_list, success: true }, status: :ok
  end

  def show
    pokemon = pokemon_by_name_or_id

    render json: { error: 'Could not find pokemon with that ID or name', success: false }, status: :bad_request and return if pokemon.nil?

    pokemon_formatted = Api::V1::PokemonDecorator.decorate(pokemon).to_show_api_format

    render json: { pokemon: pokemon_formatted, success: true }, status: :ok
  end

  private

  def pokemon_by_name_or_id
    request_param = params[:id]
    request_param_is_name = request_param.to_i.zero?

    if request_param_is_name
      Pokemon.find_by(name: request_param)
    else
      # rubocop:disable Lint/SuppressedException
      begin
        Pokemon.find(request_param)
      rescue ActiveRecord::RecordNotFound
      end
      # rubocop:enable Lint/SuppressedException
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
