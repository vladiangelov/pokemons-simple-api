require 'test_helper'

# TODO: Write a test to check that parsing next_url is handled correctly
class PokeApiImportService::ImportListTest < ActiveSupport::TestCase
  test 'PokeApiImportService::UpsertModels adds the expected number of Pokemon instances to the DB' do
    PokeApiImportService::UpsertModels.call(pokemon_results, Pokemon)

    assert_equal 2, Pokemon.all.count
  end

  test 'PokeApiImportService::UpsertModels adds the expected number of Type instances to the DB' do
    PokeApiImportService::UpsertModels.call(type_results, Type)

    assert_equal 2, Type.all.count
  end

  test 'PokeApiImportService::UpsertModels handles correctly existing instances and does not attempt to create duplicates' do
    FactoryBot.create :pokemon, name: 'bulbasaur'

    PokeApiImportService::UpsertModels.call(pokemon_results, Pokemon)

    assert_equal 2, Pokemon.all.count
  end

  private

  def pokemon_results
    [
      {
        "name" => "bulbasaur",
        "url" => "https://pokeapi.co/api/v2/pokemon/1/"
      },
      {
        "name" => "ivysaur",
        "url" => "https://pokeapi.co/api/v2/pokemon/2/"
      }
    ]
  end

  def type_results
    [
      {
        "name" => "normal",
        "url" => "https://pokeapi.co/api/v2/type/1/"
      },
      {
        "name" => "fighting",
        "url" => "https://pokeapi.co/api/v2/type/2/"
      }
    ]
  end
end
