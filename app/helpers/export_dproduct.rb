# coding: utf-8
module ExportDproduct
  require "spreadsheet"
  include DshipsHelper
  include DproductsHelper

  Spreadsheet.client_encoding = "UTF-8"  
  
  
  
  def outdproduct(dproducts,etemplate,path,user,outfilename)
    book = Spreadsheet::Workbook.new
    
    sheet1 = book.create_worksheet
    sheet1.name ='ParentListing'

    format = Spreadsheet::Format.new :size => 13,
    :vertical_align => :middle,
    :border => :thin,
    :pattern_fg_color => :white,
    :pattern => 1
    
    sheet1.row(0).default_format = format
    sheet1.row(0).height = 30
    sheet1.column(0).width =25    
    rowheight = 20
    columnweight=20
    
   
    
    

    title_arry =  etemplate.split(' ')
    
    #定位 用于计数
    c_cloum =1
  

    dproducts.each_with_index do |dproduct,a_num|

      # 根据模版生产数据
      sheet1.row(a_num+1).height =  rowheight
     
      
      title_arry.each_with_index do |t_ob,t_num|
        sheet1.column(t_num).width =columnweight 
        if(a_num==0)
          sheet1[0,t_num]=t_ob
        end
        
        # skustr = dship.sku.split(' ')
        

        
        case t_ob.upcase
        when "SKU"
          sheet1[c_cloum,t_num]= dproduct.sku
        when "NAME"
          sheet1[c_cloum,t_num]= dproduct.name
        when "CNAME"
           
          sheet1[c_cloum,t_num]= dproduct.cname
        when "WEIGHT"
          sheet1[c_cloum,t_num]= dproduct.weight
        when "DPRICE"
         
          sheet1[c_cloum,t_num]= dproduct.dprice
        when "PARENT"
          sheet1[c_cloum,t_num]= dproduct.parent
        
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
