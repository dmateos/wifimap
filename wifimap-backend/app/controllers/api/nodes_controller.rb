module Api
  class NodesController < Api::BaseController
    def create
      render json: get_resource.errors, status: :unprocessable_entity
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
