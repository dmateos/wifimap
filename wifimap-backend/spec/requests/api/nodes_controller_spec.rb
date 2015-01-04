require 'rails_helper'

RSpec.describe "Nodes API (/api/nodes/)", type: :request do
  describe "GET #index" do 
    it "gets a json index with 0 nodes" do
      get "/api/nodes/", format: :json
      expect(response).to be_success
      json = JSON.parse(response.body)
      expect(json['nodes'].count).to eq(0)
    end

    it "gets a json index with 2 nodes" do
      node = Node.create(ssid: "test1", mac: "0", signal: 0)
      node2 = Node.create(ssid: "test2", mac: "1", signal: 0)

      get "/api/nodes/", format: :json
      expect(response).to be_success

      json = JSON.parse(response.body)

      expect(json['nodes'].count).to eq(2)
    end
  end

  describe "GET #show" do
    it "gets a json entry" do
      node = Node.create(ssid: "test1", mac: "0", signal: 0)

      get "/api/nodes/#{node.id}", format: :json
      expect(response).to be_success

      json = JSON.parse(response.body)

      expect(json["respcode"]).to eq(0)
      expect(json["node"]["id"]).to eq(node.id)
    end

    it "attempts to get a non existant entry" do
      expect {
        get "/api/nodes/100", format: :json
      }.to raise_error ActiveRecord::RecordNotFound
    end
  end

  describe "POST #create" do
    it "adds a new node" do
      post "/api/nodes/", node: { ssid: "test1", mac: 0, signal: 0 }, format: :json
      
      json = JSON.parse(response.body)

      expect(json["respcode"]).to eq(0)
      expect(json["node"]["ssid"]).to eq("test1")
    end

    it "tries to add an exsisting node (same mac address and signal)" do
      node = Node.create(ssid: "test1", mac: 0, signal: 0) 
      post "/api/nodes/", node: { ssid: "test1", mac: 0, signal: 0 }, format: :json
     
      json = JSON.parse(response.body) 
      expect(json["respcode"]).to eq(1)

      node = Node.find_by(mac: 0)
      expect(node.signal).to eq(0)
    end

    it "tries to add an existing node (same mac address but better signal)" do
      node = Node.create(ssid: "test1", mac: 0, signal: -100) 
      post "/api/nodes/", node: { ssid: "test1", mac: 0, signal: -50 }, format: :json

      json = JSON.parse(response.body) 
      expect(json["respcode"]).to eq(2)

      node = Node.find_by(mac: 0)
      expect(node.signal).to eq(-50)
    end

    it "tries to add an existing node (same mac address but less signal)" do
      node = Node.create(ssid: "test1", mac: 0, signal: -100) 
      post "/api/nodes/", node: { ssid: "test1", mac: 0, signal: -105 }, format: :json

      json = JSON.parse(response.body) 
      expect(json["respcode"]).to eq(1)
    
      node = Node.find_by(mac: 0)
      expect(node.signal).to eq(-100)
    end
  end

=begin
  describe "PUT #update" do
    it" tries to update an exsisting node" do
      node = Node.create(ssid: "test1", mac: "", signal: -100) 
      put "/api/nodes/#{node.id}", id: node, node: { ssid: "test", mac: "00:00:00", signal: 10 }, 
          format: :json 
    end
  end
=end
end
