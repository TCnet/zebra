# coding: utf-8
class AlbumsController < ApplicationController
 before_action :logged_in_user, only: [:index,:edit,:show, :create, :destroy]
 before_action :correct_album, only: [:show,:edit, :update, :destroy]
 include PhotosHelper
 include AlbumsHelper
 require "spreadsheet"

 Spreadsheet.client_encoding = "UTF-8"  
 
 
  def index
   # @allalbums = current_user.albums
    @category = category_for current_user.albums
    
    sql = "name LIKE ?"
    #condition = params[:q].nil? "":"name like \%"+params[:q]+"\%"
   @albums = current_user.albums.where(sql,"%#{params[:q]}%").paginate(page: params[:page])
   # @albums = current_user.albums.search(params[:q]).paginate(page: params[:page])
  end

  

  def new
    @album = Album.new
    if !@album.brand?
      @album.brand = current_user.brand
    end
    if !@album.dnote?
      @album.dnote = current_user.note
    end
  end

  def exportexcel
    @album = Album.find(params[:id])
    @etemplate =  current_user.etemplates.first
    if(current_user.etemplates.count>0)
      @etemplate =  current_user.etemplates.order(isused: :desc).order(created_at: :desc).first
      
    else
      @etemplate = current_user.etemplates.build()
      @etemplate.name="Default_template_2015"
      @etemplate.title=DEFAULT_E
      @etemplate.isused= true
      @etemplate.save

    end
    
    title_arry = @etemplate.title.split(' ')

    

    is_in = params[:album][:is_in].downcase=="in"?true:false
    
    keywords_type = 1
    book = Spreadsheet::Workbook.new
    sheet1 = book.create_worksheet
    sheet1.name = 'Template'
    csize = album_params[:csize].upcase.split(' ')
    cloumbegin = 1
    titlecloum = 1

    cloum_item_type = cloumbegin -1
    skucloum = cloumbegin
    cloum_upc=1+cloumbegin
    cloum_upcname=2+cloumbegin
    cloum_brand = 3+cloumbegin
    cloum_item_name=4+cloumbegin
    
    cloum_color= 5+cloumbegin
    colormapcloum = 6+cloumbegin
    cloum_department =9+cloumbegin
    cloum_size = 7+cloumbegin
    sizemapcloum = 8+cloumbegin
    cloum_s_price =8+2+cloumbegin
    cloum_quantity = 9+2+cloumbegin
    imgcloum= 10+2+cloumbegin
        
    rowheight = 18
    columnwidth = 12
    

    cloum_parent_child = 19+2+cloumbegin
    cloum_parent_sku = 20+2+cloumbegin
    cloum_relationship_type=21+2+cloumbegin
    cloum_theme =22+2+cloumbegin
    decriptioncloum = 23+2+cloumbegin

   
    cloum_keywords = 31+2 +cloumbegin
    cloum_points = 30+2 + cloumbegin

    cloum_list_price = 38 + cloumbegin
    cloum_sale_price = 39 + cloumbegin
  
    parentsku = @album.name.upcase
    brand = album_params[:brand]
    dnote = album_params[:dnote]
    dname = album_params[:dname]
    fullname = album_params[:fullname]

    
    
   

    
    # add format 

    format = Spreadsheet::Format.new :size => 11,
                                     :vertical_align => :middle,
                                     :border => :thin,
                                     :pattern_fg_color => :yellow,
                                     :pattern => 1
            
    sheet1.row(0).default_format = format
    sheet1.row(0).height = 30
    sheet1.column(0).width =15
    
    @photos= @album.photos
    sizeob = @photos.find_by(name: "size.jpg")
    photos = @album.photos
    photos=photos.order("name ASC")
    if sizeob
      photos = photos.where("name <>?","size.jpg")

    end
    path= File.join Rails.root, 'public/'

    sheet1.row(1).height = rowheight

   
  
    
    
       
    
    
    code = code_for photos, current_user.imgrule
    
    ussize = to_us_size_for album_params[:ussize],csize,"Tag Size "
    
   
    otherimg_num = get_titlenumber title_arry,"other_image"
    

  

    
   

   

    
    
    #set upc
    brandname = brand   
   

    #sheet1[titlecloum,cloum_keywords] = album_params[:keywords].tr("\n",",")

    keywords_arry = album_params[:keywords].tr("\n\r",",").split(',').map{|x| x.strip }.uniq.delete_if{|x| !x.to_s.present?}
    
    #price set
    price_arry = album_params[:price].tr(" ",",").tr("|",",").split(',')

    stock_arry = stock_two_arry(code.length,csize.length,album_params[:stock])
    

    keywords_uniq = album_params[:keywords].tr("\n\r"," ").split(' ').uniq.join(' ')[0,1000]
    #album_params[:keywords] = 
    keywords_total = code.length * csize.length * 5+5

   
    
    
   


   

    # 根据模版生产数据
    title_arry.each_with_index do |t_ob,t_num|
      
      sheet1[0,t_num]=t_ob
      #设置color_map
      if(t_ob=="color_map")
        colornum = csize.length
        code.each_with_index do |f,index|
          if index ==1
          end

          csize.each_with_index do |m,j|
            rownum = index*colornum +j +2
            sheet1[rownum,t_num] = color_map_for(f)
          end
          
        end
        
      end
      #end color_map

      #设置sku
      
      skunum= csize.length
      if(t_ob=="item_sku")
        sheet1[1,t_num] = parentsku
        code.each_with_index do |n,index|
          csize.each_with_index do |m,j|
            rownum = index*skunum+j+2
            sheet1.row(rownum).height = rowheight
            sheet1[rownum,t_num] = @album.name.upcase+n.upcase+"-"+m
            
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
            sheet1[rownum,t_num] = size_map_for(m)
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
        
        
        
        dest += description_size_for album_params[:description],ussize,is_in
        if !dnote.empty?
          dest+="\n<br>"
          dest+=dnote
        end
        sheet1[1,t_num] = dest
        code.each_with_index do |f,n|
          csize.each_with_index do |e,m|
            sheet1[n*csize.length+m+2,t_num] = dest
          end
        end
      end
      #end description

     
   
   
   
   # size       
    code.each_with_index do |f,n|
      csize.each_with_index do |e,m|
        num = n*csize.length+m+titlecloum+1
        colorname = color_for(f)
        sizename = size_for(e,m," ", album_params[:ussize],album_params[:asize])

        #set points
        if(t_ob=="bullet_point1")

          points_num= get_titlenumber title_arry,"bullet_point"
          #points_num=5
          points = points_for album_params[:points]
          #points =  points.in_groups_of(points_num)
          points_num.times do |f|
            sheet1[titlecloum,t_num+f] = points[f]
            sheet1[num,t_num+f] = points[f]
            
          end

        #  sheet1[titlecloum,t_num] =  points_num
                              
        end
        #end points
        
        if(t_ob=="external_product_id_type")
          sheet1[titlecloum,t_num] = "UPC"  
          sheet1[num,t_num] = "UPC"     
        end
        
        if(t_ob=="brand_name")
          sheet1[titlecloum,t_num] = brand   
          sheet1[num,t_num] = brand   
        end
        if(t_ob=="department_name")
          sheet1[titlecloum,t_num] = "womens" 
          sheet1[num,t_num] = "womens"
          
        end
        if(t_ob=="parent_sku")
          sheet1[num,t_num] = parentsku 
        end
        if(t_ob=="parent_child")
          sheet1[titlecloum,t_num] = "Parent" 
          sheet1[num,t_num] = "Child" 
        end
        if(t_ob=="relationship_type")
          sheet1[num,t_num] = "Variation" 
        end
        if(t_ob=="variation_theme")
          sheet1[titlecloum,t_num] = "sizecolor" 
          sheet1[num,t_num] = "sizecolor" 
        end

        if(t_ob=="quantity")
          sheet1[num,t_num]= stock_arry[n][m]
        end

        if(t_ob=="color_name")
          sheet1[num,t_num]= colorname
        end
        if(t_ob=="size_name")
          sheet1[num,t_num]= sizename
        end
        if(t_ob=="item_name")
          sheet1[titlecloum,t_num] = fullname_for(brandname,fullname,"","")
          sheet1[num,t_num]=  fullname_for(brandname,fullname,colorname,sizename.tr("-","").tr("/","").split(' ').join(' '))
        end
        if(t_ob=="fulfillment_latency")
          sheet1[titlecloum,t_num] = 5
          sheet1[num,t_num] = 5
        end
        if(t_ob=="sale_from_date")
          sheet1[titlecloum,t_num] =  -2.days.from_now.strftime('%Y-%m-%d')
          sheet1[num,t_num] = -2.days.from_now.strftime('%Y-%m-%d')
        end
        if(t_ob=="sale_end_date")
          sheet1[titlecloum,t_num] =  770.days.from_now.strftime('%Y-%m-%d')
          sheet1[num,t_num] = 770.days.from_now.strftime('%Y-%m-%d')
        end
        if(t_ob=="import_designation")
          sheet1[titlecloum,t_num] =  "Imported"
          sheet1[num,t_num] = "Imported"
        end
        if(t_ob=="country_of_origin")
          sheet1[titlecloum,t_num] =  "China"
          sheet1[num,t_num] = "China"
        end
        if(t_ob=="condition_type")
          sheet1[titlecloum,t_num] =  "New"
          sheet1[num,t_num] = "New"
        end
        
        
        
        if(t_ob=="generic_keywords1")
          #keywords_num= get_titlenumber title_arry,"generic_keywords"

          if keywords_type == 1
            if(keywords_arry.length<keywords_total)
              sheet1[num,t_num] =  keywords_arry.join(',')
              
            end
          else
            #for keywords 2
            sheet1[num,t_num] =  keywords_uniq
          end
          
        end

       
          
        
        #set price
        if(price_arry.length>0)
          if(t_ob=="standard_price")
            sheet1[titlecloum,t_num] = price_arry[0].to_f.round(2)
            sheet1[num,t_num] = price_arry[0].to_f.round(2)
          end

          if(t_ob=="list_price")
            if(price_arry.length==1)
              sheet1[titlecloum,t_num] = price_arry[0].to_f.round(2)
              sheet1[num,t_num] = price_arry[0].to_f.round(2)
            elsif(price_arry.length>=2)
              sheet1[titlecloum,t_num] = price_arry[1].to_f.round(2)
              sheet1[num,t_num] = price_arry[1].to_f.round(2)
            end
          end

          if(t_ob=="sale_price")
            if(price_arry.length==1)
              sheet1[titlecloum,t_num] = price_arry[0].to_f.round(2)
              sheet1[num,t_num] = price_arry[0].to_f.round(2)
            elsif(price_arry.length>2)
              sheet1[titlecloum,t_num] = price_arry[2].to_f.round(2)
              sheet1[num,t_num] = price_arry[2].to_f.round(2)
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
          sheet1[titlecloum,t_num] =  keywords_arry.join(',')
          
        end
      else
        #for keywords 2
        sheet1[titlecloum,num] = keywords_uniq
      end




      if keywords_type==1
      
      if(keywords_arry.length > keywords_total)
        key_array= keywords_for keywords_total,keywords_arry
        
        sheet1[titlecloum,t_num] = key_array[0].join(',')
        sheet1[titlecloum,t_num+1] = key_array[1].join(',')
        sheet1[titlecloum,t_num+2] = key_array[2].join(',')
        sheet1[titlecloum,t_num+3] = key_array[3].join(',')
        sheet1[titlecloum,t_num+4] = key_array[4].join(',')
        
        code.each_with_index do |f,n|
          csize.each_with_index do |e,m|
            num = n*csize.length+m+titlecloum
            sn = (num-1)*5+5

            sheet1[num+1,t_num] = key_array[sn].join(',')
            sheet1[num+1,t_num+1] = key_array[sn+1].join(',')
            sheet1[num+1,t_num+2] = key_array[sn+2].join(',')
            sheet1[num+1,t_num+3] = key_array[sn+3].join(',')
            sheet1[num+1,t_num+4] = key_array[sn+4].join(',')
            
          end
        end
      end
      
    else
      #keywords 2
      key_array = keywords_for 4,keywords_arry

      sheet1[titlecloum,t_num+1] = key_array[0].join(',')[0,1000]
      sheet1[titlecloum,t_num+2] = key_array[1].join(',')[0,1000]
      sheet1[titlecloum,t_num+3] = key_array[2].join(',')[0,1000]
      sheet1[titlecloum,t_num+4] = key_array[3].join(',')[0,1000]

      code.each_with_index do |f,n|
        csize.each_with_index do |e,m|
          num = n*csize.length+m+titlecloum
          
          #sheet1[num+1,cloum_keywords] = key_array[0].join(',')[0,1000]
          sheet1[num+1,t_num+1] = key_array[0].join(',')[0,1000]
          sheet1[num+1,t_num+2] = key_array[1].join(',')[0,1000]
          sheet1[num+1,t_num+3] = key_array[2].join(',')[0,1000]
          sheet1[num+1,t_num+4] = key_array[3].join(',')[0,1000]
          
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
                sheet1[1,m] = geturl(d.picture.url) #
                if m==t_num
                  sheet1[1,m+otherimg_num+1]= geturl(d.picture.url) #switch img
                end
              end
              #其他行
              csize.each_with_index do |c,index|
                sheet1[j+index+1,m] = geturl(d.picture.url)
                
                #switch img 
                if m==t_num
                  sheet1[j+index+1,m+otherimg_num+1]= geturl(d.picture.url)
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
        sheet1[1,m]=url
        code.each_with_index do |b,e|
          csize.each_with_index do |c,index|
            sheet1[sizej+index+1,m] = url
            
          end
          sizej +=csize.length
        end
        
      end
      
    end
    
   
    #根据颜色分组 设置url
     
      
      
      
    end
    #end 根据模版生产数据

   

    
    
    

    #create excel
    filename = @album.name+".xls";

    file_path=path+"uploads/export/"+filename

    if File.exist?(file_path)
      File.delete(file_path)
    end
    book.write(file_path)
    @album.update_attributes(album_params)

    
    #flash[:success] = "finished"
    
    File.open(file_path, 'r') do |f|
      send_data f.read.force_encoding('BINARY'), :filename => filename, :type => "application/xls", :disposition => "inline"
    end
    #render :action=> "show"
    #redirect_to "show"

    #flash[:success] = "Export excel sucessful!"
    #redirect_to @album and return
    #redirect_to(:action => "show") and return
    #redirect_to (:back), :notice => "problem with the start_date and end_date" and return
    
    #redirect_to root_url
  end

  def show
    @category = category_for current_user.albums
    
   # @in_select={"Yes"=>true,"No"=>false}
    @album = Album.find(params[:id])
   # @user_brand = current_user.brand
   # @user_note = current_user.note
    if !@album.brand?
      @album.brand = current_user.brand
    end
    if !@album.dnote?
      @album.dnote = current_user.note
    end
    photo_url = []
    @album.photos.each do |w|
      photo_url << geturl(w.picture.url)
    end
    @photourls = photo_url.join(' ')

    @herf = herf_for @album.summary
    
    
   
  end

  

  def create
    @album = current_user.albums.build(album_params)
    @album.coverimg = "nopic.jpg"
    if @album.save
      flash[:success] = "Album created!"
      redirect_to albums_path
      
    else
      render 'new'
    end
  end

  def edit
    @album = Album.find(params[:id])
    if !@album.brand?
      @album.brand = current_user.brand
    end
    if !@album.dnote?
      @album.dnote = current_user.note
    end
  end

  def destroy
    Album.find(params[:id]).destroy
    flash[:success] = "Album deleted"
    redirect_to albums_path
  end

  def update
    @album = Album.find(params[:id])
    if @album.update_attributes(album_params)
      flash[:success] = "Album updated"
      redirect_to albums_path
    else
      render 'edit'
    end
    
    
  end
  
  private
    
    def album_params
      params.require(:album).permit(:name, :summary,:csize,:ussize,:brand,:fullname,:dname,:description,:dnote,:keywords,:points,:price,:stock,:asize)
    end

    def correct_album
      @album = Album.find(params[:id])
      redirect_to(albums_path) unless current_user.albums.include?(@album)
    end
  
end
