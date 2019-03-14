module DshipsHelper

  DEFAULT_EUB="订单号	商品交易号	商品SKU	数量	收件人姓名	收件人地址1	收件人地址2	收件人地址3	收件人城市	收件人州	收件人邮编	收件人路向	收件人电话	收件人电子邮箱	自定义信息1	备注	来源	寄件地址	发货地址	业务类型	增值服务"
  DEFAULT_EUB_SKU ="SKU编号	商品中文名称	商品英文名称	单件重量（3位小数）	单件报关价格(2位小数)	原寄地	计量单位	保存至系统SKU	税则号	销售链接	备注"
  DEFAULT_AD="LH"
  def get_eubtemplate(user)
    
    return DEFAULT_EUB
  end
  
  def get_eub_skutemplate(user)
    return DEFAULT_EUB_SKU 
  end
  
  def set_ca_price(price,country,num)
    s= price
    if(country.upcase!="UNITED STATES"&&country.upcase!="US")
      s= 15/num
    end
    return s
    
  end
  
  def ad_str(ordernum,user)
    str=ordernum
    if !str.start_with?(DEFAULT_AD)
      str=DEFAULT_AD+ordernum
    end
    return str
  end
    
  
  
end
