class APhandler
  def add_signal_sample
    location = Location.new([:signal_sample][:lat], params[:signal_sample][:lng])
    if(!access_point.locations.include?(location)
       @signal_sample = access_point.signal_samples.create(signal_sample_params)
  end

  def create_access_point

  end

  private
  def access_point
    @_access_point ||= AccessPoint.find_by_mac(params[:access_point][:mac])
  end

  def access_point_already_exists?
    access_point.nil?
  end
end

