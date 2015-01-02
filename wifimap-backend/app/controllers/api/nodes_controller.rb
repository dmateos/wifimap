module Api
  STATUS_ERR_DUPE = 1
  STATUS_UPDATE_SIGNAL = 2

  class NodesController < Api::BaseController
    def create
      @node = Node.find_by(mac: params[:mac])
      if @node.nil?
        @node = Node.new(node_params)
        @node.seencount = 1
        @node.updatecount = 1
        if @node.save
          render :show, status: :created
        end
      else
        @node.seencount += 1
        if @node.signal < params[:signal]
          old_signal = @node.signal
          @node.frequency = params[:frequency]
          @node.signal = params[:signal]
          @node.lat = params[:lat]
          @node.lng = params[:lng] 
          @node.updatecount += 1
          @node.save
          render json: {respcode: STATUS_UPDATE_SIGNAL, msg: "#{@node.ssid} #{params[:signal]}/#{old_signal}" }, status: :unprocessable_entity
        else
          @node.save
          render json: {respcode: STATUS_ERR_DUPE, msg: "#{@node.ssid}" }, status: :unprocessable_entity
        end
      end
    end

    private
      def node_params
        params.require(:node).permit( :ssid, :mac, :capabilities, :frequency, :signal, :lng, :lat )
      end
  end
end
