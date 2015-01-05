json.array!(@locations) do |location|
  json.extract! location, :id, :lat, :lng, :signal, :node_id
  json.url location_url(location, format: :json)
end
