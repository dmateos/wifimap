class Node < ActiveRecord::Base
  validates :mac, uniqueness: true
  has_many :locations

  def best_location
    locations.sort_by { |s| s.signal }.last
  end
end
