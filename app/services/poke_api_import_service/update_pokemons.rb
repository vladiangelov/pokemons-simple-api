##
# This service handles updating individual pokemons using their 'show' page
#
class PokeApiImportService::UpdatePokemons < ApplicationService
  def initialize(seconds_to_wait_between_requests)
    @seconds_to_wait_between_requests = seconds_to_wait_between_requests
  end

  def call
    Pokemon.all.each do |pokemon|
      url = "#{build_versioned_url}/pokemon/#{pokemon.name}"
      parsed_response = fetch_api_response(url)

      pokemon.update! pokemon_params(parsed_response)

      # TODO: create_pokemon_types(parsed_response)

      sleep(@seconds_to_wait_between_requests)
    end
  end

  private

  def create_pokemon_types(parsed_response); end

  def pokemon_params(parsed_response)
    {
      base_experience: parsed_response['base_experience'],
      height: parsed_response['height'],
      is_default: parsed_response['is_default'],
      order: parsed_response['order'],
      weight: parsed_response['weight']
    }
  end

  def fetch_api_response(url)
    uri = URI(url)
    response = Net::HTTP.get_response(uri)

    raise ExternalApiCallError, "Unsuccessful call to #{uri}" if response.code != '200'

    JSON.parse(response.body)
  end

  def build_versioned_url
    base_url = 'https://pokeapi.co/api'
    api_version = 2
    "#{base_url}/v#{api_version}"
  end
end
