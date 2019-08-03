module InoutplansHelper
  
  def twoarray_for_plan(inoutstr,presku)    
    ob = inoutstr.tr("\n","|").split('|')
    result = Array.new
    ob.each_with_index do |f,n|
      pref= presku.upcase + f
      result[n]= pref.split(' ')
      
    end
    return result
  end
  
  def current_warehours
    current_user.warehouses.first
  end
  
  #set 
  def set_inout(plan)
    inoutstocks= plan.inoutstocks
   
    str=""
    inoutstocks.each_with_index do |f,n|
      
      str += f.sku.upcase
      str += " "
      str += f.normal.to_s 
      str += " "
      str += f.defect.to_s
      str += " "
      str += f.sizeup.to_s
      str += " "
      str += f.sizedown.to_s
      
      
      str+="\r\n"
    end
    plan.inout = str
    plan.presku =''
    plan.save
    
    
  end
  
  #设置默认仓库
  def set_default_warehouse()
    re = Warehouse.first
    if re.nil?
       re = Warehouse.new
       re.name="默认仓库"
       re.address=""
       re.isused = true
       re.user_id = current_user.id
       re.save     
    end
    re
  end
  
  
  def out_stock(plan,warehouse)
    inoutstocks= plan.inoutstocks
    
    inoutstocks.each_with_index do |f,n|
      
      p = warehouse.inventories.find_by(sku: f.sku)
      if p.nil?
       
      else
        
        p.normal -= f.normal 
        p.defect -= f.defect
        p.sizeup -= f.sizeup
        p.sizedown -= f.sizedown
        p.save
      end
    
      
      
    end
  end
  
 
  
  def out_stock_str(inout,warehouse,presku)
    str = twoarray_for_plan(inout,presku)
    
    str.each_with_index do |f,n|
      p = warehouse.inventories.find_by(sku: f[0].upcase)
      if p.nil?
        
      else
        
      f.each_with_index do |e,m|
        if(m==0)
           p.sku = e.upcase
         elsif(m==1)
           p.normal -= e.to_i
         elsif(m==2)
           p.defect -= e.to_i
         elsif(m==3)
           p.sizeup -= e.to_i
         elsif(m==4)
           p.sizedown -= e.to_i
         end
       end
      
      p.warehouse_id= warehouse.id 
      p.save
      end
    end
  end
  
  # 根据文本入库
  def in_stock_str(inout,warehouse,presku)
    str = twoarray_for_plan(inout,presku)
    
    str.each_with_index do |f,n|
      p = warehouse.inventories.find_by(sku: f[0].upcase)
      #不存在 则新建
      if p.nil?
        p = Inventory.new   
        p.normal=0
        p.defect=0
        p.sizeup=0
        p.sizedown=0
        
        parentsku = get_parentsku f[0].upcase
        p.parentsku = parentsku
        p.name = get_name(parentsku)
        
        p.user_id = current_user.id
        f.each_with_index do |e,m|
          if(m==0)
             p.sku = e.upcase
           elsif(m==1)
             p.normal = e.to_i
           elsif(m==2)
             p.defect = e.to_i
           elsif(m==3)
             p.sizeup = e.to_i
           elsif(m==4)
             p.sizedown = e.to_i
          end
        end
        
      else
        f.each_with_index do |e,m|
          if(m==0)
             p.sku = e.upcase
           elsif(m==1)
             p.normal += e.to_i
           elsif(m==2)
             p.defect += e.to_i
           elsif(m==3)
             p.sizeup += e.to_i
           elsif(m==4)
             p.sizedown += e.to_i
          end
        end
      end
      
      
      
      p.warehouse_id= warehouse.id 
      p.save
    end
  end
#出库入库
  def in_stock(plan,warehouse)
    inoutstocks= plan.inoutstocks
    
    inoutstocks.each_with_index do |f,n|
      
     p = warehouse.inventories.find_by(sku: f.sku)
      if p.nil?
        p = Inventory.new
        p.sku = f.sku.upcase
        p.normal= f.normal
        p.defect = f.defect
        p.sizeup = f.sizeup
        p.sizedown = f.sizedown
        
        parentsku = get_parentsku f.sku
        p.parentsku = parentsku
        p.name = get_name(parentsku)
        p.user_id = current_user.id
        p.warehouse_id= warehouse.id
      else
        
        p.normal += f.normal 
        p.defect += f.defect
        p.sizeup += f.sizeup
        p.sizedown += f.sizedown
        
      end
      p.save
      
      
    end
  end
  
  def get_parentsku(sku)
    sku.upcase.match(/[A-Z]+[0-9]+/).to_s
  end
  
  def get_name(parentsku)
    parentsku.upcase.match(/[0-9]+/).to_s
  end
  
end
