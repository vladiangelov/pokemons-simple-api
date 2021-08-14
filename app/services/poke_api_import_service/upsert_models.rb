##
# This service handles model creation, when given an array of hashes with name attribute
#
class PokeApiImportService::UpsertModels < ApplicationService
  def initialize(results, model)
    super()
    @results = results
    @model = model
  end

  def call
    @results.each do |result|
      name = result['name']

      # Only add instances, if they do not existing in the database already
      existing_instance = @model.find_by(name: name)
      @model.create! name: name unless existing_instance
    end
  end
end
