class XstockplansController < ApplicationController

  def index
    @xstock_plans = current_user.xstockplans.paginate(page: params[:page])
  end

  def new
    @xstockplan = Xstockplan.new
  end
  
  def destroy
    Xstockplan.find(params[:id]).destroy
    flash[:success] = "Stock plan deleted"
    redirect_to xstock_plans_path
  end

  def edit
    @xstockplan = Xstockplan.find(params[:id])
  end

  def update
    @xstockplan =  Xstockplan.find(params[:id])
    if @xstockplan.update_attributes(xstockplan_params)
      flash[:success] = "stock plan updated"
      redirect_to xstockplans_path
    else
      render 'edit'
    end
  end

  def show
    @xstockplan = Xstockplan.find(params[:id])
    #@xstocks =Xstock.where("xstockplan_id="+params[:id])
    @xstocks = @xstockplan.xstocks
  end
  
  

  def create
    @xstockplan = current_user.xstockplans.build(xstockplan_params)
  
    if @xstockplan.save
      flash[:success] = "stock plan created!"
      redirect_to xstockplans_path
      
    else
      render 'new'
    end
  end

  private
  
    def xstockplan_params
      params.require(:xstockplan).permit(:name)
    end

  
end
