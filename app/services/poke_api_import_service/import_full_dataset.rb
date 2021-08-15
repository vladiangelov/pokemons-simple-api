##
# This is a batch service to execute the whole import sequence
#
class PokeApiImportService::ImportFullDataset < ApplicationService
  def initialize(seconds_to_wait_between_requests)
    super()
    @seconds_to_wait_between_requests = seconds_to_wait_between_requests
  end

  def call
    PokeApiImportService::ImportList.call(@seconds_to_wait_between_requests, 'pokemon')
    PokeApiImportService::ImportList.call(@seconds_to_wait_between_requests, 'type')
    PokeApiImportService::UpdatePokemons.call(@seconds_to_wait_between_requests)
  end
end
