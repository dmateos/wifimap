require 'rails_helper'

RSpec.describe NodesController, type: :controller do
  describe "GET #index" do
    it "populates an array of nodes" do 
      node = Node.create(ssid: "", mac: "", signal: 0)
      get :index
      expect(assigns(:nodes)).to eq([node])
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "GET #show" do
    it "assigns the requested node to @node" do
      node = Node.create(ssid: "", mac: "", signal: 0)
      get :show, id: node
      expect(assigns(:node)).to eq(node)
    end

    it "renders the show template" do
      get :show, id: Node.create(ssid: "", mac: "", signal: 0)
      expect(response).to render_template("show")
    end
  end

  describe "GET #new" do
    context "with admin user" do
      before :each do
        sign_in FactoryGirl.create(:admin_user)
        get :new
      end

      it "assigns a new contact to @contact" do
        expect(assigns(:node)).to be_a(Node)
      end

      it "renderes the new template" do
        expect(response).to render_template("new")
      end
    end

    context "with normal user" do
      before :each do
        sign_in FactoryGirl.create(:user)
        get :new
      end

      it "assigns a new contact to @contact" do
        expect(assigns(:node)).to be_a(Node)
      end

      it "redirects new to index" do
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET #edit" do
    context "with admin user" do
      before :each do
        sign_in FactoryGirl.create(:admin_user)
        @node = Node.create(ssid: "", mac: "", signal: 0)
        get :edit, id: @node
      end

      it "assigns edit contact to @edit" do
        expect(assigns(:node)).to eq(@node)
      end

      it "renderes the edit template" do
        expect(response).to render_template("edit")
      end
    end

    context "with normal user" do
      before :each do
        sign_in FactoryGirl.create(:user)
        @node = Node.create(ssid: "", mac: "", signal: 0)
        get :edit, id: @node
      end

      it "assigns edit contact to @edit" do
        expect(assigns(:node)).to eq(@node)
      end

      it "redirects edit to index" do
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "POST #create" do
    context "with admin user" do
      before :each do
        sign_in FactoryGirl.create(:admin_user)
      end

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

    context "with normal user" do
      before:each do
        sign_in FactoryGirl.create(:user)
      end

      it "fails to create the requested node" do
        expect {
          post :create, node: {ssid: "test", mac: "00:00:00", signal: 10}
        }.to change(Node, :count).by(0)
      end

      it "redirects create to index" do
        post :create, node: {ssid: "test", mac: "00:00:00", signal: 10}
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "PUT #update" do
    before :each do
      @node = Node.create(ssid: "", mac: "", signal: 0)
    end

    context "with admin user" do
      before :each do
        sign_in FactoryGirl.create(:admin_user)
      end

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

    context "with normal user" do 
      before do
        sign_in FactoryGirl.create(:user)
      end

      it "located the requested node" do
        put :update, id: @node, node: {ssid: "test", mac: "00:00:00", signal: 10}
        expect(assigns(:node)).to eq(@node)
      end

      it "does not change @nodes values" do
        put :update, id: @node, node: { ssid: "test", mac: "00:00:00", signal: 11 }
        @node.reload
        expect(@node.ssid).to eq("")
      end

      it "redirects update to index" do
        put :update, id: @node, node: {ssid: "test", mac: "00:00:00", signal: 10}
        expect(response).to redirect_to(root_path)
      end
    end
  end
  
  describe "DELETE #destroy" do
    before :each do
      @node = Node.create(ssid: "", mac: "", signal: 0)
    end

    context "with admin user" do
      before :each do
        sign_in FactoryGirl.create(:admin_user)
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

    context "with normal user" do
      before :each do 
        sign_in FactoryGirl.create(:user)
      end

      it "doesnt destroy the requested node" do
        expect {
          delete :destroy, id: @node
        }.to change(Node, :count).by(0)
      end

      it "redirects to index" do
        delete :destroy, id: @node
        expect(response).to redirect_to(root_path) 
      end
    end
  end
end
