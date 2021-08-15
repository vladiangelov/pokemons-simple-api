require 'test_helper'

class PokeApiImportService::CreatePokemonTypesTest < ActiveSupport::TestCase
  def setup
    @bulbasaur = FactoryBot.create :pokemon, name: 'bulbasaur'
    FactoryBot.create :type, name: 'grass'
    FactoryBot.create :type, name: 'poison'
  end

  test 'creates two new pokemon_types' do
    PokeApiImportService::CreatePokemonTypes.call(@bulbasaur, bulbasaur_types)

    assert_equal 2, PokemonType.all.count
  end

  test 'first pokemon_type has correct asssociated pokemon and type' do
    PokeApiImportService::CreatePokemonTypes.call(@bulbasaur, bulbasaur_types)

    assert_equal 'grass', PokemonType.first.type.name
    assert_equal 'bulbasaur', PokemonType.first.pokemon.name
  end

  private

  # Disable rubocop for the following methods, as they constitute mocked API responses

  # rubocop:disable Metrics/MethodLength
  def bulbasaur_types
    [
      {
        "slot" => 1,
        "type" => {
          "name" => "grass",
          "url" => "https://pokeapi.co/api/v2/type/12/"
        }
      },
      {
        "slot" => 2,
        "type" => {
          "name" => "poison",
          "url" => "https://pokeapi.co/api/v2/type/4/"
        }
      }
    ]
  end
  # rubocop:enable Metrics/MethodLength
end
