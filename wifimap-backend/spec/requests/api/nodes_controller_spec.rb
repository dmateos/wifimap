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
      node = FactoryGirl.create(:node)
      node2 = FactoryGirl.create(:node)

      get "/api/nodes/", format: :json
      expect(response).to be_success

      json = JSON.parse(response.body)

      expect(json['nodes'].count).to eq(2)
    end
  end

  describe "GET #show" do
    it "gets a json entry" do
      node = FactoryGirl.create(:node)

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
end
