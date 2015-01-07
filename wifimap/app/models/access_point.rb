class AccessPoint < ActiveRecord::Base
  has_many :signal_samples

  def locations
    signal_samples.map { |s|
      s.location
    }
  end
end
