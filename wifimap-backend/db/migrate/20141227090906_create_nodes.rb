class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.string :ssid
      t.string :mac
      t.float :lng
      t.float :lat

      t.timestamps
    end
  end
end
