class WarehousesController < ApplicationController
  def index
    
    @warehouses = current_user.warehouses
  end
end
