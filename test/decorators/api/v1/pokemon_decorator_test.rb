require "test_helper"

class Api::V1::PokemonDecoratorTest < Draper::TestCase
  def setup
    @bulbasaur = FactoryBot.create :pokemon, {
      name: 'bulbasaur',
      base_experience: 64,
      height: 7,
      poke_api_id: 1,
      is_default: true,
      order: 1,
      weight: 69
    }
    @fighting = FactoryBot.create :type, name: 'fighting'
    FactoryBot.create :pokemon_type, pokemon: @bulbasaur, type: @fighting
  end

  test 'successfully decorates a Pokemon instance with a method to output index_api_response' do
    index_api_format_pokemon = Api::V1::PokemonDecorator.decorate(@bulbasaur).to_index_api_format

    assert_equal expected_index_format, index_api_format_pokemon
  end

  test 'successfully decorates a Pokemon instance with a method to output to_show_api_format' do
    show_api_format_pokemon = Api::V1::PokemonDecorator.decorate(@bulbasaur).to_show_api_format

    assert_equal expected_show_format, show_api_format_pokemon
  end

  def expected_index_format
    {
      id: @bulbasaur.id,
      name: "bulbasaur",
      types: [
        { name: "fighting" }
      ]
    }
  end

  def expected_show_format
    { id: @bulbasaur.id,
      name: "bulbasaur",
      types: [
        { name: "fighting" }
      ],
      poke_api_id: 1,
      base_experience: 64,
      height: 7,
      is_default: true,
      order: 1,
      weight: 69 }
  end
end
