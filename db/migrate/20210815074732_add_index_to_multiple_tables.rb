##
# Add indexes to pokemon and type name fields, for faster searching
# Add poke_api_id to pokemon, for back-reference
#
class AddIndexToMultipleTables < ActiveRecord::Migration[6.1]
  def change
    add_index :pokemons, :name
    add_index :types, :name
    add_column :pokemons, :poke_api_id, :integer
  end
end
