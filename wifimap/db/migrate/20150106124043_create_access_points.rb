class CreateAccessPoints < ActiveRecord::Migration
  def change
    create_table :access_points do |t|
      t.string :ssid
      t.string :mac, null: false
      t.string :freq
      t.string :capabilities

      t.timestamps null: false
    end
  end
end
