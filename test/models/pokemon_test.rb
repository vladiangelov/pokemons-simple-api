require "test_helper"

class PokemonTest < ActiveSupport::TestCase
  test 'create a pokemon instance' do
    pokemon = FactoryBot.create :pokemon, :with_details

    assert_equal 'Bulbasaur', pokemon.name
  end
end
