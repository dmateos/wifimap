class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.string :ssid
      t.string :mac
      t.string :capabilities

      t.integer :frequency
      t.integer :signal

      t.float :lng
      t.float :lat

      t.timestamps
    end
  end
end
