require 'rails_helper'

RSpec.describe LocationsController, type: :controller do
  describe "GET #index" do
    it "populates an array of locations" do 
      location = FactoryGirl.create(:location)
      get :index
      expect(assigns(:locations)).to eq([location])
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "GET #show" do
    it "assigns the requested location to @location" do
      location = FactoryGirl.create(:location)
      get :show, id: location
      expect(assigns(:location)).to eq(location)
    end

    it "renders the show template" do
      get :show, id: FactoryGirl.create(:location)
      expect(response).to render_template("show")
    end
  end

  describe "GET #new" do
    context "with admin user" do
      before :each do
        sign_in FactoryGirl.create(:admin_user)
        get :new
      end

      it "assigns a new location to @location" do
        expect(assigns(:location)).to be_a(Location)
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

      it "assigns a new location to @location" do
        expect(assigns(:location)).to be_a(Location)
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
        @location = FactoryGirl.create(:location)
        get :edit, id: @location
      end

      it "assigns edit location to @edit" do
        expect(assigns(:location)).to eq(@location)
      end

      it "renderes the edit template" do
        expect(response).to render_template("edit")
      end
    end

    context "with normal user" do
      before :each do
        sign_in FactoryGirl.create(:user)
        @location = FactoryGirl.create(:location)
        get :edit, id: @location
      end

      it "assigns edit location to @edit" do
        expect(assigns(:location)).to eq(@location)
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

      it "creates the requested location" do
        expect {
          post :create, location: {signal: 0, lat: 0.0, lng: 0.0}
        }.to change(Location, :count).by(1)
      end

      it "redirects to the new location" do
        post :create, location: {signal: 0, lat: 0.0, lng: 0.0}
        expect(response).to redirect_to(Location.last)
      end
    end

    context "with normal user" do
      before:each do
        sign_in FactoryGirl.create(:user)
      end

      it "fails to create the requested location" do
        expect {
          post :create, location: {signal: 0, lat: 0.0, lng: 0.0}
        }.to change(Location, :count).by(0)
      end

      it "redirects create to index" do
        post :create, location: {signal: 0, lat: 0.0, lng: 0.0}
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "PUT #update" do
    before :each do
      @location = FactoryGirl.create(:location)
    end

    context "with admin user" do
      before :each do
        sign_in FactoryGirl.create(:admin_user)
        put :update, id: @location, location: {signal: 99, lat: 0.0, lng: 0.0}
      end

      it "located the requested location" do
        expect(assigns(:location)).to eq(@location)
      end 

      it "changes @locations values" do
        @location.reload
        expect(@location.signal).to eq(99)
      end

      it "redirects to the updated location" do
        expect(response).to redirect_to(@location)
      end
    end

    context "with normal user" do 
      before do
        sign_in FactoryGirl.create(:user)
      end

      it "located the requested location" do
        put :update, id: @location, location: {signal: 0, lat: 0.0, lng: 0.0}
        expect(assigns(:location)).to eq(@location)
      end

      it "does not change @locations values" do
        put :update, id: @location, location: {signal: 0, lat: 0.0, lng: 0.0}
        signal = @location.signal
        @location.reload
        expect(@location.signal).to eq(signal)
      end

      it "redirects update to index" do
        put :update, id: @location, location: {signal: 0, lat: 0.0, lng: 0.0}
        expect(response).to redirect_to(root_path)
      end
    end
  end
  
  describe "DELETE #destroy" do
    before :each do
      @location = FactoryGirl.create(:location)
    end

    context "with admin user" do
      before :each do
        sign_in FactoryGirl.create(:admin_user)
      end

      it "destroys the requested location" do
        expect {
          delete :destroy, id: @location
        }.to change(Location, :count).by(-1)
      end

      it "redirects to location#index" do
        delete :destroy, id: @location
        expect(response).to redirect_to(Location) 
      end
    end

    context "with normal user" do
      before :each do 
        sign_in FactoryGirl.create(:user)
      end

      it "doesnt destroy the requested location" do
        expect {
          delete :destroy, id: @location
        }.to change(Location, :count).by(0)
      end

      it "redirects to index" do
        delete :destroy, id: @location
        expect(response).to redirect_to(root_path) 
      end
    end
  end
end
