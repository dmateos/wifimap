class NodesController < ApplicationController
  before_action :set_node, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @nodes = Node.all
    respond_with(@nodes)
  end

  def show
    respond_with(@node)
  end

  def new
    @node = Node.new
    authorize @node
    respond_with(@node)
  end

  def edit
    authorize @node
  end

  def create
    @node = Node.new(node_params)
    authorize @node
    @node.save 
    respond_with(@node)
  end

  def update
    authorize @node
    @node.update(node_params)
    respond_with(@node)
  end

  def destroy
    authorize @node
    @node.destroy
    respond_with(Node)
  end

  private
    def set_node
      @node = Node.find(params[:id])
    end

    def node_params
      params.require(:node).permit(:ssid, :mac, :frequency, :capabilities)
    end
end


