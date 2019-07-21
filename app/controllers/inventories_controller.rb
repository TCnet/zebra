class InventoriesController < ApplicationController
  include InoutplansHelper
  
  #当前库存
  def index
    @warehouse = current_user.warehouses.first
    if @warehouse.nil?
      @warehouse = set_default_warehouse
    end
    
    @inventories = @warehouse.inventories.order(parentsku: :asc).order(sku: :asc).paginate(page: params[:page])
  end
  
  def destroy
    
    @inventory = Inventory.find(params[:id])
    sku=@inventory.sku
    @inventory.destroy
    flash[:success] = sku+" deleted"
    redirect_to inventories_path(@inventory)
  end
  
  
end
