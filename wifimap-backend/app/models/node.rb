class Node < ActiveRecord::Base
  validates :mac, uniqueness: true
end
