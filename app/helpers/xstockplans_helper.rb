module XstockplansHelper
  
  def for_plan_num(monthsold,keypa,plannum)
    if plannum>0
      plannum
    else
      monthsold*keypa
    end
  end

  def for_stock_num(homenum,fbanum,monthsold,keypa=2,planum)

    num=for_plan_num(monthsold,keypa,planum)-fbanum-homenum
    if num<0
      num =0
    end
    return num
    
  end
end
