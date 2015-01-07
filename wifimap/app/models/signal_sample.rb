class SignalSample < ActiveRecord::Base
  belongs_to :access_point

  def location
    Location.new(lat, lng)
  end
end
