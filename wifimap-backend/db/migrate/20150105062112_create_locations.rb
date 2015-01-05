class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.decimal :lat, null: false, precision: 15, scale: 13
      t.decimal :lng, null: false, precision: 16, scale: 13
      t.integer :signal, null: false
      t.references :node, index: true
      t.timestamps null: false
    end
    add_foreign_key :locations, :nodes
  end
end
