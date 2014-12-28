json.array!(@nodes) do |node|
  json.extract! node, :id, :ssid, :mac, :lng, :lat
  json.url node_url(node, format: :json)
end
