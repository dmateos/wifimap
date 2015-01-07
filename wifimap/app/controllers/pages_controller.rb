class PagesController < ApplicationController
  def index
    @signal_samples = SignalSample.all.map { |s|
      { lat: s.lat, lng: s.lng, infowindow: s.access_point.ssid }
    }
  end
end
