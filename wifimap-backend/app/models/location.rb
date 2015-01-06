class Location < ActiveRecord::Base
  belongs_to :node

  def rough_distance
    exp = (27.55 - (20 * Math.log10(node.frequency)) + signal.abs) / 20.0;
    10.0 ** exp
  end
end
