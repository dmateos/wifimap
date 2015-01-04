module Api
  STATUS_ERR_DUPE = 1
  STATUS_UPDATE_SIGNAL = 2
  STATUS_ERROR_UNKNOWN = 3

  class NodesController < Api::BaseController
    def create
      @node = Node.find_by(mac: params[:node][:mac])
      if @node.nil?
        @node = Node.new(node_params)
        if @node.save
          render :show, status: :created
        end
      else
        @node.seencount += 1
        if @node.signal < params[:node][:signal].to_i #rspec sends this as a string...
          old_signal = @node.signal
          @node.update(node_update_signal_params)
          @node.updatecount += 1
          @node.save
          render json: {respcode: STATUS_UPDATE_SIGNAL, msg: "#{@node.ssid} 
                        #{params[:node][:signal]}/#{old_signal}" }, status: :unprocessable_entity
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

      def node_update_signal_params
        params.require(:node).permit( :frequency, :signal, :lat, :lng )
      end
  end
end
