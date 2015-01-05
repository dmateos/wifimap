class Node < ActiveRecord::Base
  validates :mac, uniqueness: true

  has_many :locations
end
