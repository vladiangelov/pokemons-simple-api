require "test_helper"

# rubocop:disable Metrics/ClassLength
class Api::V1::PokemonsControllerTest < ActionDispatch::IntegrationTest
  def setup
    types.each { |type| FactoryBot.create :type, name: type }
    type_instances = Type.all

    pokemons.each do |pokemon|
      pokemon_instance = FactoryBot.create :pokemon, name: pokemon
      type_instances.each do |type_instance|
        FactoryBot.create :pokemon_type, pokemon: pokemon_instance, type: type_instance
      end
    end

    @bulbasaur = Pokemon.find_by(name: 'bulbasaur')
    @bulbasaur.update!(bulbasaur_full_params)
  end

  test 'request to #index is sucessful with no params' do
    get api_v1_pokemons_path

    assert_response :success
  end

  test 'request to #index is sucessful with offset and limit params' do
    get api_v1_pokemons_path, params: { offset: 5, limit: 5 }

    assert_response :success
  end

  test 'request to #index with no params returns 11 pokemons (20 is default limit)' do
    get api_v1_pokemons_path

    parsed_response = JSON.parse(response.body)
    pokemon_count = parsed_response['pokemon'].size

    assert_equal 11, pokemon_count
  end

  test 'request to #index with non numeric params defaults and returns 11 pokemons (20 is default limit)' do
    get api_v1_pokemons_path, params: { offset: 'foo', limit: 'bar' }

    parsed_response = JSON.parse(response.body)
    pokemon_count = parsed_response['pokemon'].size

    assert_equal 11, pokemon_count
  end

  test 'request to #index with offset and limit params returns 5 pokemons offset correctly' do
    get api_v1_pokemons_path, params: { offset: 5, limit: 5 }

    parsed_response = JSON.parse(response.body)
    sixth_pokemon = parsed_response['pokemon'].first
    pokemon_count = parsed_response['pokemon'].size

    assert_equal 5, pokemon_count
    assert_equal 'charizard', sixth_pokemon['name']
  end

  test 'request to #index with offset and limit params returns correct total count of pokemons' do
    get api_v1_pokemons_path, params: { offset: 5, limit: 5 }

    parsed_response = JSON.parse(response.body)
    total_count = parsed_response['total_count']

    assert_equal 11, total_count
  end

  test 'request to #index with offset and limit params returns correct value for next page if true' do
    get api_v1_pokemons_path, params: { offset: 5, limit: 5 }

    parsed_response = JSON.parse(response.body)
    next_page = parsed_response['next_page']

    assert next_page
  end

  test 'request to #index with offset and limit params returns correct value for next page if false' do
    get api_v1_pokemons_path, params: { offset: 10, limit: 5 }

    parsed_response = JSON.parse(response.body)
    next_page = parsed_response['next_page']

    assert_not next_page
  end

  test 'request to #index with incompatible offset and limit returns bad request' do
    get api_v1_pokemons_path, params: { offset: 5, limit: 6 }

    assert_response :bad_request
  end

  test 'request to #index with incompatible offset and limit returns expected error message' do
    get api_v1_pokemons_path, params: { offset: 5, limit: 6 }

    parsed_response = JSON.parse(response.body)
    expected_error = 'Offset should be divisible by limit (limit is 20, if not supplied)'

    assert_equal expected_error, parsed_response['error']
  end

  test 'request to #index with incompatible max number of items returns bad request' do
    get api_v1_pokemons_path, params: { limit: 200 }

    assert_response :bad_request
  end

  test 'request to #index with incompatible max number of items returns expected error message' do
    get api_v1_pokemons_path, params: { limit: 200 }

    parsed_response = JSON.parse(response.body)
    expected_error = 'Maximum 100 items on a page'

    assert_equal expected_error, parsed_response['error']
  end

  test 'request to #show is sucessful with a correct ID' do
    get api_v1_pokemon_path(@bulbasaur.id)

    assert_response :success
  end

  test 'request to #show is sucessful with a correct name' do
    get api_v1_pokemon_path(@bulbasaur.name)

    assert_response :success
  end

  test 'request to #show is unsuccessfull with an incorrect name' do
    get api_v1_pokemon_path('Incorrect')

    assert_response :bad_request
  end

  test 'request to #show is unsuccessfull with an incorrect ID' do
    get api_v1_pokemon_path(@bulbasaur.id + 100)

    assert_response :bad_request
  end

  test 'request to #show returns correct output' do
    get api_v1_pokemon_path(@bulbasaur.name)

    bulbasaur_respose = JSON.parse(response.body)

    assert_equal expected_bulbasaur_response, bulbasaur_respose
  end

  private

  def bulbasaur_full_params
    {
      base_experience: 64,
      height: 7,
      poke_api_id: 1,
      is_default: true,
      order: 1,
      weight: 69
    }
  end

  # rubocop:disable Metrics/MethodLength
  def expected_bulbasaur_response
    {
      "pokemon" => {
        "id" => @bulbasaur.id,
        "name" => "bulbasaur",
        "types" => [
          {
            "name" => "normal"
          },
          {
            "name" => "fighting"
          }
        ],
        "poke_api_id" => 1,
        "base_experience" => 64,
        "height" => 7,
        "is_default" => true,
        "order" => 1,
        "weight" => 69
      },
      "success" => true
    }
  end
  # rubocop:enable Metrics/MethodLength

  def pokemons
    %w[bulbasaur ivysaur venusaur charmander charmeleon charizard squirtle wartortle blastoise caterpie metapod]
  end

  def types
    %w[normal fighting]
  end
end
# rubocop:enable Metrics/ClassLength
