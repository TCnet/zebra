module DproductsHelper
 
  DEFAULT_DPRO ="SKU	Name	Cname	Weight	Dprice	Parent"
  def get_dproduct(sku,user)
    #str = sku.upcase.split('-')[0]
    
    #q= str[0,str.length-2]
    q= sku.upcase.match(/[A-Z]+[0-9]+/).to_s
    sql = "sku LIKE ?"
    user.dproducts.where(sql,"%#{q}%").first
    
  end
  
  def get_dproduct_template(user)
    return DEFAULT_DPRO 
  end
end
