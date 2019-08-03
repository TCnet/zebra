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
    
    @char_group =  @warehouse.inventories.all.group_by{|ob| ob.parentsku}
    
    #flash[:danger] = @char_group.last.count
    labstr=""
    normalstr = ""
    defectstr= ""
    sizeupstr=""
    sizedownstr =""
    @char_group.each do |parentsku,chars|
      labstr+= (parentsku) 
      labstr+= "|"
      normal=0
      defect=0
      sizeup =0
      sizedown=0
      chars.each do |char|
        normal+=char.normal
        defect+= char.defect
        sizeup +=char.sizeup
        sizedown += char.sizedown
        
      end
      normalstr+= normal.to_s
      normalstr+=" "
      defectstr+= defect.to_s
      defectstr+=" "
      sizeupstr+= sizeup.to_s
      sizeupstr+=" "
      sizedownstr+= sizedown.to_s
      sizedownstr+=" "
      normal=0
      defect=0
      sizeup =0
      sizedown=0
      
      
    end
   
   
    @normllist = normalstr.split(' ')
    @defectlist = defectstr.split(' ')
    @sizeuplist = sizeupstr.split(' ')
    @sizedownlist = sizedownstr.split(' ')
    @labes = labstr.split('|')
    
    @bgcolor= random_color(@labes.count)
    @bg2 = random_color(@labes.count)
    @bg3 = random_color(@labes.count)
    @bg4 = random_color(@labes.count)
    
	  @data = {		  
	    labels: @labes,
	    datasets: [
	      {
	          label: "Normal",   
	          data: @normllist,
			      backgroundColor: @bgcolor      
	      },
        {
          label: "Defect",   
          data: @defectlist,
		     backgroundColor: @bg2       
        },
        {
          label: "SizeUp",   
          data: @sizeuplist,
		      backgroundColor: @bg3  
        },
        {
          label: "SizeDown",   
          data: @sizedownlist,
		      backgroundColor: @bg4
        }
        
	      
	    ]
	  }
	  @options = { width: 400,height: 120 }
    
    
  end
  
  def destroy
    
    @inventory = Inventory.find(params[:id])
    sku=@inventory.sku
    @inventory.destroy
    flash[:success] = sku+" deleted"
    redirect_to inventories_path(@inventory)
  end
  
  
end
