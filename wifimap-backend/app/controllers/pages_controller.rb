class PagesController < ApplicationController
  def index
#    @location_hash = Location.select { |n|
#       n.lat != nil and n.lng != nil
#    }.map { |m| 
#      { lat: m.lat, lng: m.lng, infowindow: m.node.ssid }
#    }

    @location_hash = Node.all.map { |n|
      { lat: n.best_location.lat, lng: n.best_location.lng, infowindow: n.ssid }
    } 
  end
end
