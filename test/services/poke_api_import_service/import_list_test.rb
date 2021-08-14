require 'test_helper'

# TODO: Write a test to check that parsing next_url is handled correctly
class PokeApiImportService::ImportListTest < ActiveSupport::TestCase
  test 'PokeApiImportService::UpsertModels is called with model type and correct result from the API' do
    stub_get_request('type', 200, type_index_response)

    assert_called_with(PokeApiImportService::UpsertModels, :call, [type_index_response['results'], Type]) do
      PokeApiImportService::ImportList.call(0.5, 'type')
    end
  end

  test 'PokeApiImportService::UpsertModels is called with model pokemon and correct result from the API' do
    stub_get_request('pokemon', 200, pokemon_index_response)

    assert_called_with(PokeApiImportService::UpsertModels, :call, [pokemon_index_response['results'], Pokemon]) do
      PokeApiImportService::ImportList.call(0.5, 'pokemon')
    end
  end

  test 'PokeApiImportService::UpsertModels must raise an error, when response code is not 200' do
    stub_get_request('pokemon', 400, pokemon_index_response)

    assert_raises ExternalApiCallError do
      PokeApiImportService::ImportList.call(0.5, 'pokemon')
    end
  end

  private

  def stub_get_request(type_of_list, status, response)
    stub_request(:get, "https://pokeapi.co/api/v2/#{type_of_list}").to_return(
      status: status,
      headers: {
        content_type: 'application/json'
      },
      body: response.to_json
    )
  end

  # Disable rubocop for the following methods, as they constitute mocked API responses

  # rubocop:disable Metrics/MethodLength
  def type_index_response
    {
      "count" => 20,
      "next" => nil,
      "previous" => nil,
      "results" => [
        {
          "name" => "normal",
          "url" => "https://pokeapi.co/api/v2/type/1/"
        },
        {
          "name" => "fighting",
          "url" => "https://pokeapi.co/api/v2/type/2/"
        }
      ]
    }
  end

  def pokemon_index_response
    {
      "count" => 20,
      "next" => nil,
      "previous" => nil,
      "results" => [
        {
          "name" => "bulbasaur",
          "url" => "https://pokeapi.co/api/v2/pokemon/1/"
        },
        {
          "name" => "ivysaur",
          "url" => "https://pokeapi.co/api/v2/pokemon/2/"
        }
      ]
    }
  end
  # rubocop:enable Metrics/MethodLength
end
