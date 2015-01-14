module Api::V1
  class AccessPointsApiController < ApplicationController
    protect_from_forgery with: :null_session

    def create_or_update
      #aphandler = APhandler.new

      if access_point_already_exists?
        add_signal_sample_to_access_point
      else
        create_new_access_point
      end
    end

    private
    def add_signal_sample_to_access_point
      location = Location.new(params[:signal_sample][:lat], params[:signal_sample][:lng])
      if !access_point.locations.include?(location)
        @signal_sample = access_point.signal_samples.create(signal_sample_params)
        render json: {respcode: 0, msg:
          "access_point: #{access_point.mac}, signal_sample: #{@signal_sample.id}"
        }, status: :created
      else
        render json: {respcode: 1, msg:
          "signal_sample already exsists"
        }, status: :created
      end
    end

    def create_new_access_point
      @access_point = AccessPoint.create(access_point_params)
      @signal_sample = @access_point.signal_samples.create(signal_sample_params)
      render json: {respcode: 0, msg:
        "access_point: #{@access_point.mac}, signal_sample: #{@signal_sample.id}"
      }, status: :created
    end

    def access_point_already_exists?
      !access_point.nil?
    end

    def access_point
      @_aceess_point ||= AccessPoint.find_by_mac(params[:access_point][:mac])
    end

    def access_point_params
      params.require(:access_point).permit(:ssid, :mac, :freq, :capabilities)
    end

    def signal_sample_params
      params.require(:signal_sample).permit(:signal, :lat, :lng)
    end
  end
end
