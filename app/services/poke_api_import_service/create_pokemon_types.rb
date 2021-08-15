##
# This service handles create all pokemon types for one pokemon
#
class PokeApiImportService::CreatePokemonTypes < ApplicationService
  def initialize(pokemon, types_array)
    super()
    @types_array = types_array
    @pokemon = pokemon
  end

  def call
    @types_array.each do |type|
      type = Type.find_by(name: type.dig('type', 'name'))

      PokemonType.create! pokemon: @pokemon, type: type
    end
  end
end
