class LocationsController < ApplicationController
  before_action :set_location, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @node = Node.find(params[:node_id])
    @locations = @node.locations
    respond_with(@locations)
  end

  def show
    respond_with(@location)
  end

  def new
    @location = Location.new
    authorize @location
    respond_with(@location)
  end

  def edit
    authorize @location
  end

  def create
    @location = Location.new(location_params)
    authorize @location
    @location.save
    respond_with(@location)
  end

  def update
    authorize @location
    @location.update(location_params)
    respond_with(@location)
  end

  def destroy
    authorize @location
    @location.destroy
    respond_with(@location)
  end

  private
    def set_location
      @location = Location.find(params[:id])
    end

    def location_params
      params.require(:location).permit(:lat, :lng, :signal, :node_id)
    end
end
