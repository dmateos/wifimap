class PagesController < ApplicationController
  def index
    @signal_samples_hash = AccessPoint.all.map { |ap| 
      signal_sample = ap.signal_samples.sort_by { |ss| ss.signal }.last
      { lat: signal_sample.lat, lng: signal_sample.lng, infowindow: "#{ap.ssid} #{signal_sample.signal}" }
    }
  end
end
