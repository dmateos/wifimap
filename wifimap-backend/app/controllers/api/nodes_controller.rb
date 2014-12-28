module Api
  class NodesController < Api::BaseController
    private
      def node_params
        params.require(:node).permit(
          :ssid, :mac, :capabilities, 
          :frequency, :signal, :lng, :lat
        )
      end
  end
end
