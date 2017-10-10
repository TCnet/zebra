class XstocksController < ApplicationController

  def destroy
    
    @xstock = Xstock.find(params[:id])
    xstockplan = @xstock.xstockplan
    @xstock.destroy
    flash[:success] = "Stock deleted"
    redirect_to xstockplan_path(xstockplan)
  end
  
end
