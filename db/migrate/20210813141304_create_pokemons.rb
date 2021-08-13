##
# Migration to create pokemon model
#
class CreatePokemons < ActiveRecord::Migration[6.1]
  def change
    create_table :pokemons do |t|
      t.string :name
      t.integer :base_experience
      t.integer :height
      t.boolean :is_default
      t.integer :order
      t.integer :weight

      t.timestamps
    end
  end
end
