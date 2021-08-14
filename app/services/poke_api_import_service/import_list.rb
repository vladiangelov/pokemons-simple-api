##
# Import all pokemons from Poke API
# Apply simple throttle to outgoing requests (fair use policy of Poke API)
# Recommended throttle 0.5s between requests (2 requests per second)
#
class PokeApiImportService::ImportList < ApplicationService
  def initialize(seconds_to_wait_between_requests, model)
    super()
    @seconds_to_wait_between_requests = seconds_to_wait_between_requests
    @next_url = "#{build_versioned_url}/#{model}"
    @model = model
  end

  def call
    while @next_url
      parsed_response = fetch_api_response
      results = parsed_response['results']

      case @model
      when 'pokemon'
        PokeApiImportService::UpsertModels.call(results, Pokemon)
      when 'type'
        PokeApiImportService::UpsertModels.call(results, Type)
      end

      @next_url = parsed_response['next']

      sleep(@seconds_to_wait_between_requests)
    end
  end

  private

  def fetch_api_response
    uri = URI(@next_url)
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
