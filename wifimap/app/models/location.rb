class Location
  attr_reader :lat, :lng
  def initialize(lat, lng)
    @lat = lat
    @lng = lng
  end

  def ==(other)
    same_float?(@lat, other.lat) && same_float?(@lng, other.lng)
  end

  private
  def same_float?(a, b)
    a.round(13) == b.round(13)
  end
end
