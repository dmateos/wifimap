class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.string :ssid, null: false
      t.string :mac, null: false
      t.string :capabilities

      t.integer :frequency
      t.integer :signal, null: false

      t.float :lng
      t.float :lat

      t.integer :seencount, default: 1
      t.integer :updatecount, default: 1

      t.timestamps
    end
  end
end
