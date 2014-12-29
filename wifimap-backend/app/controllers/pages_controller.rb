class PagesController < ApplicationController
  def index
    @node_hash = Node.all.map { |m| 
      { lat: m.lat, lng: m.lng }
    }
  end
end
