require 'test_helper'

class PokeApiImportService::UpdatePokemonsTest < ActiveSupport::TestCase
  def setup
    FactoryBot.create :pokemon, name: 'bulbasaur'
    FactoryBot.create :pokemon, name: 'ivysaur'
    FactoryBot.create :type, name: 'grass'
    FactoryBot.create :type, name: 'poison'
  end

  test 'calling PokeApiImportService::UpdatePokemons correctly updates base experience of all pokemons' do
    stub_get_request('bulbasaur', 200, bulbasaur_payload)
    stub_get_request('ivysaur', 200, ivysaur_payload)

    PokeApiImportService::UpdatePokemons.call(0.5)

    assert_equal 64, Pokemon.find_by(name: 'bulbasaur').base_experience
    assert_equal 142, Pokemon.find_by(name: 'ivysaur').base_experience
  end

  test 'calling PokeApiImportService::UpdatePokemons correctly updates height of all pokemons' do
    stub_get_request('bulbasaur', 200, bulbasaur_payload)
    stub_get_request('ivysaur', 200, ivysaur_payload)

    PokeApiImportService::UpdatePokemons.call(0.5)

    assert_equal 7, Pokemon.find_by(name: 'bulbasaur').height
    assert_equal 10, Pokemon.find_by(name: 'ivysaur').height
  end

  test 'calling PokeApiImportService::UpdatePokemons logs an error and rescues if response from one request is not 200' do
    stub_get_request('bulbasaur', 400, bulbasaur_payload)
    stub_get_request('ivysaur', 200, ivysaur_payload)

    log_message = "Unsuccessful call to https://pokeapi.co/api/v2/pokemon/bulbasaur"

    assert_called_with(Rails.logger, :error, [log_message]) do
      PokeApiImportService::UpdatePokemons.call(0.5)
    end
  end

  test 'calling PokeApiImportService::UpdatePokemons rescues and continues to update the other pokemons if response from one request is not 200' do
    stub_get_request('bulbasaur', 400, bulbasaur_payload)
    stub_get_request('ivysaur', 200, ivysaur_payload)

    PokeApiImportService::UpdatePokemons.call(0.5)

    assert_equal 142, Pokemon.find_by(name: 'ivysaur').base_experience
  end

  private

  def stub_get_request(pokemon_name, status, response)
    stub_request(:get, "https://pokeapi.co/api/v2/pokemon/#{pokemon_name}").to_return(
      status: status,
      headers: {
        content_type: 'application/json'
      },
      body: response.to_json
    )
  end

  # Disable rubocop for the following methods, as they constitute mocked API responses

  # rubocop:disable Metrics/MethodLength
  def bulbasaur_payload
    {
      "base_experience" => 64,
      "height" => 7,
      "id" => 1,
      "is_default" => true,
      "name" => "bulbasaur",
      "order" => 1,
      "types" => [
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
      ],
      "weight" => 69
    }
  end

  def ivysaur_payload
    {
      "base_experience" => 142,
      "height" => 10,
      "id" => 2,
      "is_default" => true,
      "name" => "ivysaur",
      "order" => 2,
      "types" => [
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
      ],
      "weight" => 130
    }
  end
  # rubocop:enable Metrics/MethodLength
end
