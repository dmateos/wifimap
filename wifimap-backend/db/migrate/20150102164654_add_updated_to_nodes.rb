class AddUpdatedToNodes < ActiveRecord::Migration
  def change
    add_column :nodes, :updatecount, :integer
  end
end
