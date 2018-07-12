# coding: utf-8
module ExportExcel
  include AlbumsHelper
  require "spreadsheet"

  Spreadsheet.client_encoding = "UTF-8"  
  
  def outamazon(albums,etemplate,path,user,outfilename)
   

    book = Spreadsheet::Workbook.new
    sheet1 = book.create_worksheet
    sheet1.name = 'Template'

    format = Spreadsheet::Format.new :size => 11,
                                     :vertical_align => :middle,
                                     :border => :thin,
                                     :pattern_fg_color => :yellow,
                                     :pattern => 1
    
    sheet1.row(0).default_format = format
    sheet1.row(0).height = 30
    sheet1.column(0).width =15    
    rowheight = 18
    sheet1.row(1).height =  rowheight

    #albums = Album.find_by ids

    

    title_arry = etemplate.title.split(' ')

    #定位 用于计数
    c_cloum =0
    

    albums.each_with_index do |album,a_num|
      #album.update_all()
      photos = album.photos
      sizeob = photos.find_by(name: "size.jpg")
      
      photos=photos.order("name ASC")
      if sizeob
        photos = photos.where("name <>?","size.jpg")
      end

      
      code = code_for photos, user.imgrule
      
      
      keywords_type=1
      is_in=false
      otherimg_num = get_titlenumber title_arry,"other_image"
      parentsku = album.name.upcase
      brand = album.brand
      brandname = brand
      dnote = album.dnote
      dname = album.dname
      fullname = album.fullname
      csize = album.csize.upcase.split(' ')
      ussize = to_us_size_for album.ussize,csize,"Tag Size "
      keywords_arry = album.keywords.tr("\n\r",",").split(',').map{|x| x.strip }.uniq.delete_if{|x| !x.to_s.present?}
      price_arry = album.price.nil?? " " : album.price.tr(" ",",").tr("|",",").split(',')
      stock_arry = album.stock.nil?? " " : stock_two_arry(code.length,csize.length,album.stock)
      keywords_uniq = album.keywords.tr("\n\r"," ").split(' ').uniq.join(' ')[0,1000]
      #album_params[:keywords] = 
      keywords_total = code.length * csize.length * 5+5

      
      

      
      
      # 根据模版生产数据
      
      title_arry.each_with_index do |t_ob,t_num|
        if(a_num==0)
          sheet1[0,t_num]=t_ob
        end
        #设置color_map
        if(t_ob=="color_map")
          colornum = csize.length
          code.each_with_index do |f,index|
            if index ==1
            end

            csize.each_with_index do |m,j|
              rownum = index*colornum +j +2
              sheet1[rownum+c_cloum,t_num] = color_map_for(f)
            end
            
          end
          
        end
        #end color_map

        #设置sku
        
        skunum= csize.length
        if(t_ob=="item_sku")
          sheet1[1+c_cloum,t_num] = parentsku
          code.each_with_index do |n,index|
            csize.each_with_index do |m,j|
              rownum = index*skunum+j+2
              #sheet1.row(rownum+c_cloum).height = rowheight
              sheet1[rownum+c_cloum,t_num] = album.name.upcase+n.upcase+"-"+m
              
            end
          end
          
        end
        #end sku

        # set size_map
        if(t_ob=="size_map")
          sizenum = csize.length
          code.each_with_index do |f,index|
            if index ==1
            end

            csize.each_with_index do |m,j|
              rownum = index*sizenum +j +2
              sheet1[rownum+c_cloum,t_num] = size_map_for(m)
            end
            
          end
          
        end
        #end size_map

        #set description  
        if(t_ob=="product_description")
          
          
          dest = "";
          if !brand.empty?
            dest +="Brand: <strong>"+brand+"</strong><br><br>\n"
          end
          if !dname.empty?
            dest += dname.gsub("\n","<br>") +"<br>\n"
          end
          
          
          
          dest += description_size_for album.description,ussize,is_in
          if !dnote.empty?
            dest+="\n<br>"
            dest+=dnote
          end
          sheet1[1+c_cloum,t_num] = dest
          code.each_with_index do |f,n|
            csize.each_with_index do |e,m|
              sheet1[n*csize.length+m+2+c_cloum,t_num] = dest
            end
          end
        end
        #end description

         # size       
    code.each_with_index do |f,n|
      csize.each_with_index do |e,m|
        num = n*csize.length+m+1+1
        colorname = color_for(f)
        sizename = size_for(e,m," ", album.ussize,album.asize)

        #set points
        if(t_ob=="bullet_point1")

          points_num= get_titlenumber title_arry,"bullet_point"
          #points_num=5
          points = points_for album.points
          #points =  points.in_groups_of(points_num)
          points_num.times do |f|
            sheet1[1+c_cloum,t_num+f] = points[f]
            sheet1[num+c_cloum,t_num+f] = points[f]
            
          end

        #  sheet1[titlecloum,t_num] =  points_num
                              
        end
        #end points
        
        if(t_ob=="external_product_id_type")
          sheet1.row(1+c_cloum).height = rowheight
          sheet1.row(num+c_cloum).height = rowheight
          sheet1[1+c_cloum,t_num] = "UPC"  
          sheet1[num+c_cloum,t_num] = "UPC"     
        end
        
        if(t_ob=="brand_name")
          sheet1[1+c_cloum,t_num] = brand   
          sheet1[num+c_cloum,t_num] = brand   
        end
        if(t_ob=="department_name")
          sheet1[1+c_cloum,t_num] = "womens" 
          sheet1[num+c_cloum,t_num] = "womens"
          
        end
        if(t_ob=="parent_sku")
          sheet1[num+c_cloum,t_num] = parentsku 
        end
        if(t_ob=="parent_child")
          sheet1[1+c_cloum,t_num] = "Parent" 
          sheet1[num+c_cloum,t_num] = "Child" 
        end
        if(t_ob=="relationship_type")
          sheet1[num+c_cloum,t_num] = "Variation" 
        end
        if(t_ob=="variation_theme")
          sheet1[1+c_cloum,t_num] = "sizecolor" 
          sheet1[num+c_cloum,t_num] = "sizecolor" 
        end

        if(t_ob=="quantity")
          sheet1[num+c_cloum,t_num]= stock_arry[n][m]
        end

        if(t_ob=="color_name")
          sheet1[num+c_cloum,t_num]= colorname
        end
        if(t_ob=="size_name")
          sheet1[num+c_cloum,t_num]= sizename
        end
        if(t_ob=="item_name")
          sheet1[1+c_cloum,t_num] = fullname_for(brandname,fullname,"","")
          sheet1[num+c_cloum,t_num]=  fullname_for(brandname,fullname,colorname,sizename.tr("/","-").split(' ').join(' '))
        end
        if(t_ob=="fulfillment_latency")
          sheet1[1+c_cloum,t_num] = 5
          sheet1[num+c_cloum,t_num] = 5
        end
        if(t_ob=="sale_from_date")
          sheet1[1+c_cloum,t_num] =  -2.days.from_now.strftime('%Y-%m-%d')
          sheet1[num+c_cloum,t_num] = -2.days.from_now.strftime('%Y-%m-%d')
        end
        if(t_ob=="sale_end_date")
          sheet1[1+c_cloum,t_num] =  770.days.from_now.strftime('%Y-%m-%d')
          sheet1[num+c_cloum,t_num] = 770.days.from_now.strftime('%Y-%m-%d')
        end
        if(t_ob=="import_designation")
          sheet1[1+c_cloum,t_num] =  "Imported"
          sheet1[num+c_cloum,t_num] = "Imported"
        end
        if(t_ob=="country_of_origin")
          sheet1[1+c_cloum,t_num] =  "China"
          sheet1[num+c_cloum,t_num] = "China"
        end
        if(t_ob=="condition_type")
          sheet1[1+c_cloum,t_num] =  "New"
          sheet1[num+c_cloum,t_num] = "New"
        end
        
        
        
        if(t_ob=="generic_keywords1")
          #keywords_num= get_titlenumber title_arry,"generic_keywords"

          if keywords_type == 1
            if(keywords_arry.length<keywords_total)
              sheet1[num+c_cloum,t_num] =  keywords_arry.join(',')
              
            end
          else
            #for keywords 2
            sheet1[num+c_cloum,t_num] =  keywords_uniq
          end
          
        end

       
          
        
        #set price
        if(price_arry.length>0)
          if(t_ob=="standard_price")
            sheet1[1+c_cloum,t_num] = price_arry[0].to_f.round(2)
            sheet1[num+c_cloum,t_num] = price_arry[0].to_f.round(2)
          end

          if(t_ob=="list_price")
            if(price_arry.length==1)
              sheet1[1+c_cloum,t_num] = price_arry[0].to_f.round(2)
              sheet1[num+c_cloum,t_num] = price_arry[0].to_f.round(2)
            elsif(price_arry.length>=2)
              sheet1[1+c_cloum,t_num] = price_arry[1].to_f.round(2)
              sheet1[num+c_cloum,t_num] = price_arry[1].to_f.round(2)
            end
          end

          if(t_ob=="sale_price")
            if(price_arry.length==1)
              sheet1[1+c_cloum,t_num] = price_arry[0].to_f.round(2)
              sheet1[num+c_cloum,t_num] = price_arry[0].to_f.round(2)
            elsif(price_arry.length>2)
              sheet1[1+c_cloum,t_num] = price_arry[2].to_f.round(2)
              sheet1[num+c_cloum,t_num] = price_arry[2].to_f.round(2)
            end
          end
                    
                        
        end
        
        
                             
        
      end
    end
    #end

        #设置keywors
    
    if(t_ob=="generic_keywords1")

      if keywords_type == 1
        if(keywords_arry.length<keywords_total)
          sheet1[1+c_cloum,t_num] =  keywords_arry.join(',')
          
        end
      else
        #for keywords 2
        sheet1[1+c_cloum,num] = keywords_uniq
      end




      if keywords_type==1
      
      if(keywords_arry.length > keywords_total)
        key_array= keywords_for keywords_total,keywords_arry
        
        sheet1[1+c_cloum,t_num] = key_array[0].join(',')
        sheet1[1+c_cloum,t_num+1] = key_array[1].join(',')
        sheet1[1+c_cloum,t_num+2] = key_array[2].join(',')
        sheet1[1+c_cloum,t_num+3] = key_array[3].join(',')
        sheet1[1+c_cloum,t_num+4] = key_array[4].join(',')
        
        code.each_with_index do |f,n|
          csize.each_with_index do |e,m|
            num = n*csize.length+m+1
            sn = (num-1)*5+5

            sheet1[num+1+c_cloum,t_num] = key_array[sn].join(',')
            sheet1[num+1+c_cloum,t_num+1] = key_array[sn+1].join(',')
            sheet1[num+1+c_cloum,t_num+2] = key_array[sn+2].join(',')
            sheet1[num+1+c_cloum,t_num+3] = key_array[sn+3].join(',')
            sheet1[num+1+c_cloum,t_num+4] = key_array[sn+4].join(',')
            
          end
        end
      end
      
    else
      #keywords 2
      key_array = keywords_for 4,keywords_arry

      sheet1[1+c_cloum,t_num+1] = key_array[0].join(',')[0,1000]
      sheet1[1+c_cloum,t_num+2] = key_array[1].join(',')[0,1000]
      sheet1[1+c_cloum,t_num+3] = key_array[2].join(',')[0,1000]
      sheet1[1+c_cloum,t_num+4] = key_array[3].join(',')[0,1000]

      code.each_with_index do |f,n|
        csize.each_with_index do |e,m|
          num = n*csize.length+m+1
          
          #sheet1[num+1,cloum_keywords] = key_array[0].join(',')[0,1000]
          sheet1[num+1+c_cloum,t_num+1] = key_array[0].join(',')[0,1000]
          sheet1[num+1+c_cloum,t_num+2] = key_array[1].join(',')[0,1000]
          sheet1[num+1+c_cloum,t_num+3] = key_array[2].join(',')[0,1000]
          sheet1[num+1+c_cloum,t_num+4] = key_array[3].join(',')[0,1000]
          
        end
      end
      
    end
      
    #end 设置keywors
    end

    #根据颜色分组 设置url
    if(t_ob=="main_image_url")
      j=1
      code.each do |b|
        
        m=t_num
        photos.each do |d|
          name=d.name[0,2].downcase
          if b==name
            if m<otherimg_num+t_num
              if j==1 #第一行 
                sheet1[1+c_cloum,m] = geturl(d.picture.url) #
                if m==t_num
                  sheet1[1+c_cloum,m+otherimg_num+1]= geturl(d.picture.url) #switch img
                end
              end
              #其他行
              csize.each_with_index do |c,index|
                sheet1[j+index+1+c_cloum,m] = geturl(d.picture.url)
                
                #switch img 
                if m==t_num
                  sheet1[j+index+1+c_cloum,m+otherimg_num+1]= geturl(d.picture.url)
                end
                
              end
              
            end
            
            m+=1
          end
          
        end
        j +=csize.length                
      end
      
    end

    #设置 sizeimg
    if(t_ob=="swatch_image_url")
      if sizeob
        m = t_num-1
        sizej=1
        url=geturl(sizeob.picture.url)
        sheet1[1+c_cloum,m]=url
        code.each_with_index do |b,e|
          csize.each_with_index do |c,index|
            sheet1[sizej+index+1+1+c_cloum,m] = url
            
          end
          sizej +=csize.length
        end
        
      end
      
    end
    #end sizeimg



        
        
      end
      #end # 根据模版生产数据
      c_cloum+= code.length * csize.length+1

      
    end
    #end albums 



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
  #end out

  


  
end
