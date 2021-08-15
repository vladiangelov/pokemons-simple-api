require 'test_helper'

class PokeApiImportService::ImportFullDatasetTest < ActiveSupport::TestCase
  test 'PokeApiImportService::ImportFullDataset calls the three sub services' do
    assert_called(PokeApiImportService::ImportList, :call, times: 2) do
      assert_called(PokeApiImportService::UpdatePokemons, :call) do
        PokeApiImportService::ImportFullDataset.call(0.5)
      end
    end
  end
end
