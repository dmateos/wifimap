FactoryGirl.define do
  factory :node do
    ssid "test.lan"
    sequence(:mac) { |n| "00:00:00:#{n}" }
    capabilities "WPA/2"
    frequency 2400
  end
end
