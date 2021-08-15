require "test_helper"

class Api::V1::PokemonDecoratorTest < Draper::TestCase
  test 'successfully decorates a Pokemon instance with a method to output index_api_response' do
    bulbasaur = FactoryBot.create :pokemon, name: 'bulbasaur'
    fighting = FactoryBot.create :type, name: 'fighting'
    FactoryBot.create :pokemon_type, pokemon: bulbasaur, type: fighting

    index_api_format_pokemon = Api::V1::PokemonDecorator.decorate(bulbasaur).to_index_api_format

    expected_format = {
      id: bulbasaur.id,
      name: "bulbasaur",
      types: [
        { name: "fighting" }
      ]
    }

    assert_equal expected_format, index_api_format_pokemon
  end
end
