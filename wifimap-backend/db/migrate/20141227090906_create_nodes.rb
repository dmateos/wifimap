class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.string :ssid, null: false
      t.string :mac, null: false
      t.string :capabilities
      t.integer :frequency
      t.timestamps
    end
  end
end
