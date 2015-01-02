class AddSeenToNodes < ActiveRecord::Migration
  def change
    add_column :nodes, :seencount, :integer
  end
end
