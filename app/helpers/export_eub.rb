# coding: utf-8
module ExportEub
  require "spreadsheet"
  include DshipsHelper
  include DproductsHelper

  Spreadsheet.client_encoding = "UTF-8"  
  
  
  
  def outeub(dships,etemplate,skutemp,path,user,outfilename)
    book = Spreadsheet::Workbook.new
    
    sheet1 = book.create_worksheet
    sheet1.name ='订单信息'

    format = Spreadsheet::Format.new :size => 13,
    :vertical_align => :middle,
    :border => :thin,
    :pattern_fg_color => :red,
    :pattern => 1
    
    sheet1.row(0).default_format = format
    sheet1.row(0).height = 30
    sheet1.column(0).width =25    
    rowheight = 20
    columnweight=20
    
    sheet2 =book.create_worksheet
    sheet2.name="SKU编号"
    sheet2.row(0).default_format = format
    sheet2.row(0).height = 30
    sheet2.column(0).width =25 
    
    
    

    title_arry =  etemplate.split(' ')
    sku_arry = skutemp.split(' ')
    #定位 用于计数
    c_cloum =1

    dships.each_with_index do |dship,a_num|

      # 根据模版生产数据
      sheet1.row(a_num+1).height =  rowheight
       sheet2.row(a_num+1).height =  rowheight
      
      title_arry.each_with_index do |t_ob,t_num|
        sheet1.column(t_num).width =columnweight 
        if(a_num==0)
          sheet1[0,t_num]=t_ob
        end
        
        skustr = dship.sku.split(' ')
        

        
        case t_ob
         when "订单号"
           sheet1[c_cloum,t_num]= ad_str(dship.ordernum,user) 
         when "商品SKU"
           sheet1[c_cloum,t_num]= skustr[0]
         when "数量"
           sheet1.column(t_num).width =columnweight/2
           sheet1[c_cloum,t_num]= dship.num
         when "收件人姓名"
           sheet1[c_cloum,t_num]= dship.name
         when "收件人地址1"
           sheet1.column(t_num).width =columnweight+10
           sheet1[c_cloum,t_num]= dship.address1
         when "收件人地址2"
           sheet1[c_cloum,t_num]= dship.address2
         when "收件人地址3"
           sheet1[c_cloum,t_num]= dship.address3
         when "收件人城市"
           sheet1[c_cloum,t_num]= dship.city
         when "收件人州"
           sheet1[c_cloum,t_num]= dship.state
         when "收件人邮编"
           sheet1[c_cloum,t_num]= dship.zip
         when "收件人路向"
           sheet1[c_cloum,t_num]= dship.country
         when "收件人电话"
           sheet1[c_cloum,t_num]= dship.phone
         when "收件人电子邮箱"
           sheet1[c_cloum,t_num]= dship.email
         when "自定义信息1"
           sheet1[c_cloum,t_num]= dship.customize
         when "备注"
           sheet1[c_cloum,t_num]= dship.remark
         when "来源"
           sheet1[c_cloum,t_num]= dship.source
         when ""
        end
        
        
      end
      
      
      sku_arry.each_with_index do |t_ob,t_num|
        sheet2.column(t_num).width =columnweight 
        if(a_num==0)
          sheet2[0,t_num]=t_ob
        end
        skustr = dship.sku.split(' ')
        dpro = get_dproduct(skustr[0],user)
        
        case t_ob
         when "SKU编号"
           sheet2[c_cloum,t_num]= skustr[0]
         when "商品中文名称"
           if dpro
             sheet2[c_cloum,t_num]= dpro.cname+" "+dship.sku
           else
             sheet2[c_cloum,t_num]= dship.sku
           end
         when "商品英文名称"
           if dpro
             sheet2[c_cloum,t_num]= dpro.name 
           end
         when "单件重量（3位小数）"
           if dpro
             sheet2[c_cloum,t_num]= dpro.weight 
           end
         when "单件报关价格(2位小数)"
           if dpro
             sheet2[c_cloum,t_num]= set_ca_price(dpro.dprice,dship.country,dship.num)
           end
         
          
           
           
           
        end
      end
      
      c_cloum += 1
      
    end

 
    #end dship
  
    #create excel
    filename = outfilename+".xls";

    file_path=path+"uploads/export/"+filename

    if File.exist?(file_path)
      File.delete(file_path)
    end
    book.write(file_path)
 
  
    File.open(file_path, 'r') do |f|
      send_data f.read.force_encoding('BINARY'), :filename => filename, :type => "application/xls", :disposition => "inline"
    end
  end
end
