##
# Migration to create pokemon type model (many to many)
#
class CreatePokemonTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :pokemon_types do |t|
      t.references :pokemon, null: false, foreign_key: true
      t.references :type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
