class SignalSamplesController < ApplicationController
  before_action :set_signal_sample, only: [:show, :edit, :update, :destroy]
  
  def index
    @access_point = AccessPoint.find(params[:access_point_id])
    @signal_samples = @access_point.signal_samples
  end

  def show
  end

  def new
    @access_point = AccessPoint.find(params[:access_point_id])
    @signal_sample = SignalSample.new 
  end

  def create
    @access_point = AccessPoint.find(params[:access_point_id])
    @signal_sample = SignalSample.new(signal_sample_params)
    @signal_sample.save
    respond_to do |format|
      format.html { redirect_to access_point_signal_sample_path(@access_point, @signal_sample) }
    end
  end

  def edit
  end

  def update
    @signal_sample.update(signal_sample_params)
    @signal_sample.save

    respond_to do |format|
      format.html { redirect_to access_point_signal_sample_path(@access_point, @signal_sample) }
    end
  end

  def destroy
    @signal_sample.destroy
    respond_to do |format|
      format.html { redirect_to access_point_signal_samples_path(@access_point) }
    end
  end

  private
  def set_signal_sample
    @access_point = AccessPoint.find(params[:access_point_id])
    @signal_sample = SignalSample.find(params[:id])
  end

  def signal_sample_params
    params.require(:signal_sample).permit(:signal, :lat, :lng, :access_point_id)
  end
end
