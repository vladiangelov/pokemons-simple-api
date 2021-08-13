require "test_helper"

class PokemonTypeTest < ActiveSupport::TestCase
  test 'create a pokemon_type instance' do
    FactoryBot.create :pokemon_type

    assert_equal 1, PokemonType.all.size
  end
end
