module Api
  class NodesController < Api::BaseController
    def create
      @node = Node.find_by_mac(params[:node][:mac])
      if @node.nil?
        @node = Node.new(node_params)
        @node.save

        @location = Location.new(location_params)
        @location.node = @node
        @location.save
        render :show, status: :created
      else
        @location = Location.new(location_params)
        @location.node = @node

        @location.save if @node.locations.select { |n| 
          n.lat.round(13) == @location.lat && n.lng.round(13) == @location.lng 
        }.empty? 

        if @location.id
          render json: {respcode: 0, msg: "new location for #{@node.ssid}" }, status: :updated
        else
          render json: {respcode: 1, msg: "error, location already exists for #{@node.ssid}" }, status: :unprocessable_entity
        end
      end
    end

    private
      def node_params
        params.require(:node).permit( :ssid, :mac, :capabilities, :frequency)
      end

      def location_params
        params.require(:location).permit(:signal, :lat, :lng)
      end
  end
end
