class InventoriesController < ApplicationController
  before_action :logged_in_user, only: [:index,:edit,:show, :create, :destroy]
  include InoutplansHelper
  
  #当前库存
  def index
    @warehouse = current_user.warehouses.first
    if @warehouse.nil?
      @warehouse = set_default_warehouse
    end
    
    @inventories = @warehouse.inventories.order(parentsku: :asc).order(sku: :asc)
    @normal =@inventories.sum(:normal)
    @defect = @inventories.sum(:defect)
    @sizeup = @inventories.sum(:sizeup)
     @sizedown = @inventories.sum(:sizedown)
    @total = @normal+@defect+ @sizeup+ @sizedown
  end
  
  def destroy
    
    @inventory = Inventory.find(params[:id])
    sku=@inventory.sku
    @inventory.destroy
    flash[:success] = sku+" deleted"
    redirect_to inventories_path(@inventory)
  end
  
  
end
