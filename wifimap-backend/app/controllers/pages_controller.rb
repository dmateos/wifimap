class PagesController < ApplicationController
  def index
    @node_hash = Node.select { |n|
       n.lat != nil and n.lng != nil
    }.map { |m| 
      { lat: m.lat, lng: m.lng }
    }
  end
end
