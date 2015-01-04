require 'rails_helper'

RSpec.describe NodesController, type: :controller do
  describe "GET #index" do
    it "renderes the index template" do
      get :index
      expect(response).to render_template("index")
    end
  
    it "populates an array of nodes" do 
      node = Node.create(ssid: "", mac: "", signal: 0)
      get :index
      expect(assigns(:nodes)).to eq([node])
    end
  end

  describe "GET #show" do
    it "renders the show template" do
      get :show, id: Node.create(ssid: "", mac: "", signal: 0)
      expect(response).to render_template("show")
    end

    it "assigns the requested node to @node" do
      node = Node.create(ssid: "", mac: "", signal: 0)
      get :show, id: node
      expect(assigns(:node)).to eq(node)
    end
  end

  describe "GET #new" do
    it "renderes the new template" do
      get :new
      expect(response).to render_template("new")
    end

    it "assigns a new contact to @contact" do
      get :new
      expect(assigns(:node)).to be_a(Node)
    end
  end

  describe "GET #edit" do
    it "renders the edit template" do
      node = Node.create(ssid: "", mac: "", signal: 0)
      get :edit, id: node
      expect(assigns(:node)).to eq(node)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates the requested node" do
        expect {
          post :create, node: {ssid: "test", mac: "00:00:00", signal: 10}
        }.to change(Node, :count).by(1)
      end

      it "redirects to the new node" do
        post :create, node: {ssid: "test", mac: "00:00:00", signal: 10}
        expect(response).to redirect_to(Node.last)
      end
    end
  end

  describe "PUT #update" do
    before :each do
      @node = Node.create(ssid: "", mac: "", signal: 0)
    end

    context "with valid params" do
      it "located the requested node" do
        put :update, id: @node, node: {ssid: "test", mac: "00:00:00", signal: 10}
        expect(assigns(:node)).to eq(@node)
      end 

      it "changes @nodes values" do
        put :update, id: @node, node: { ssid: "test", mac: "00:00:00", signal: 11 }
        @node.reload
        expect(@node.ssid).to eq("test")
      end

      it "redirects to the updated node" do
        put :update, id: @node, node: { ssid: "test", mac: "00:00:00", signal: 11 }
        expect(response).to redirect_to(@node)
      end
    end
  end
  
  describe "DELETE #destroy" do
    before :each do
      @node = Node.create(ssid: "", mac: "", signal: 0)
    end

    it "destroys the requested node" do
      expect {
        delete :destroy, id: @node
      }.to change(Node, :count).by(-1)
    end

    it "redirects to node#index" do
      delete :destroy, id: @node
      expect(response).to redirect_to(Node) 
    end
  end
end
