module Api
  class NodesController < Api::BaseController
    def create
      node = Node.where(mac: params[:mac])
      if node.empty?
        super
      else
        node = node.first
        if node.signal >= params[:signal]
          render json: {status: 1, msg: "#{node.ssid}" }, status: :unprocessable_entity
        else
          render json: {status: 2, msg: "#{node.ssid} #{params[:signal]}/#{node.signal}" }, status: :unprocessable_entity
        end
      end
    end

    private
      def node_params
        params.require(:node).permit(
          :ssid, :mac, :capabilities, 
          :frequency, :signal, :lng, :lat
        )
      end
  end
end
