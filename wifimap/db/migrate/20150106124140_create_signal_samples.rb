class CreateSignalSamples < ActiveRecord::Migration
  def change
    create_table :signal_samples do |t|
      t.integer :signal, null: false
      t.decimal :lat, null: false, precision: 15, scale: 13
      t.decimal :lng, null: false, precision: 16, scale: 13
      t.references :access_point, index: true

      t.timestamps null: false
    end
  end
end
