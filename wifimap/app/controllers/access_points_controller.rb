class AccessPointsController < ApplicationController
  before_action :set_access_point, only: [:show, :edit, :update, :destroy]

  def index
    @access_points = AccessPoint.all
  end

  def show
  end

  def new
    @access_point = AccessPoint.new
  end

  def create
    @access_point = AccessPoint.new(access_point_params)
    @access_point.save
    respond_to do |format|
      format.html { redirect_to @access_point }
    end
  end

  def edit
  end

  def update
    @access_point.update(access_point_params)
    respond_to do |format|
      format.html { redirect_to @access_point }
    end
  end

  def destroy
    @access_point.destroy
    respond_to do |format|
      format.html { redirect_to access_points_path }
    end
  end

  private
  def set_access_point
    @access_point = AccessPoint.find(params[:id])
  end

  def access_point_params
    params.require(:access_point).permit(:ssid, :mac, :freq, :capabilities)
  end
end
