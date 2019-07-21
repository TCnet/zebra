class InoutstocksController < ApplicationController
  include InoutplansHelper
    
  def destroy
    
    
    @inoutstock = Inoutstock.find(params[:id])
    inoutplan = @inoutstock.inoutplan
    
    out_stock_str(inoutplan.inout,current_warehours)
    
    @inoutstock.destroy
    set_inout(inoutplan)

    in_stock_str(inoutplan.inout,current_warehours)
    
    flash[:success] = "Stock deleted"
    redirect_to inoutplan_path(inoutplan)
  end
end
