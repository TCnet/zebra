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
    cloum_department =6+cloumbegin
    cloum_size = 7+cloumbegin
    cloum_s_price =8+cloumbegin
    cloum_quantity = 9+cloumbegin
    imgcloum= 10+cloumbegin

    
    rowheight = 18
    columnwidth = 12
    

    cloum_parent_child = 19+cloumbegin
    cloum_parent_sku = 20+cloumbegin
    cloum_relationship_type=21+cloumbegin
    cloum_theme =22+cloumbegin
    decriptioncloum = 23+cloumbegin

    colormapcloum = 36+cloumbegin
    cloum_keywords = 31 +cloumbegin
    cloum_points = 30 + cloumbegin
    sizemapcloum = 37+cloumbegin
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

   
    #set imgurl title
    title="MainImgUrl"
    7.times do |f|
      title += " "
      title =title+"OtherImgUrl"+(f+1).to_s
    end
    title +=" SwichImgUrl"
    str= title.split(' ')
    #sheet1.row(0).concat str
    sheet1[0,skucloum]="SKU"

    str.each_with_index do |f,num|
      cnum = imgcloum+num
      sheet1.column(cnum).width = columnwidth
      sheet1[0,cnum] = f
      
    end
    
    
       
    
    
    code = code_for photos, current_user.imgrule
    
    ussize = to_us_size_for album_params[:ussize],csize,"Tag Size "
    
    #set description  
    sheet1[0,decriptioncloum] = "Description"
    #dearray= twoarray_for params["dsize"]
    # render  dearray[0][3]
    
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
    sheet1[1,decriptioncloum] = dest
    code.each_with_index do |f,n|
      csize.each_with_index do |e,m|
        sheet1[n*csize.length+m+2,decriptioncloum] = dest
      end
    end
    
    

    # set size_map
    sheet1[0,sizemapcloum] = "size_map"
    sizenum = csize.length
    code.each_with_index do |f,index|
      if index ==1
      end

      csize.each_with_index do |m,j|
        rownum = index*sizenum +j +2
        sheet1[rownum,sizemapcloum] = size_map_for(m)
      end
      
    end

    #设置color_map
    sheet1[0,colormapcloum] = "color_map"
    colornum = csize.length
    code.each_with_index do |f,index|
      if index ==1
      end

      csize.each_with_index do |m,j|
        rownum = index*colornum +j +2
        sheet1[rownum,colormapcloum] = color_map_for(f)
      end
      
    end
    #设置sku
    
    skunum= csize.length
    sheet1.row(1).height = rowheight
    sheet1[1,skucloum] = parentsku
    code.each_with_index do |n,index|
      csize.each_with_index do |m,j|
        rownum = index*skunum+j+2
        sheet1.row(rownum).height = rowheight
        sheet1[rownum,skucloum] = @album.name.upcase+n.upcase+"-"+m
        
      end
    end

    #根据颜色分组 设置url
    j=1
    code.each do |b|
      
      m=imgcloum
      photos.each do |d|
        name=d.name[0,2].downcase
        if b==name
          if m<7+imgcloum
            if j==1 #第一行 
              sheet1[1,m] = geturl(d.picture.url) #
              if m==imgcloum
                sheet1[1,m+8]= geturl(d.picture.url) #switch img
              end
            end
            #其他行
            csize.each_with_index do |c,index|
              sheet1[j+index+1,m] = geturl(d.picture.url)
              
              #switch img 
              if m==imgcloum
                sheet1[j+index+1,m+8]= geturl(d.picture.url)
              end
              
            end
            
          end
          
          m+=1
        end
        
      end
      j +=csize.length                
    end

    #设置 sizeimg
    if sizeob
      m=imgcloum+7
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
    
    #set upc
    brandname = brand
    sheet1[0,cloum_upc]="external_product_id"
    sheet1[0,cloum_upcname] = "external_product_id_type"
    sheet1[0,cloum_brand] = "brand_name"
    sheet1[0,cloum_department] = "department_nam"
    sheet1[0,cloum_parent_sku] = "parent_sku"
    sheet1[0,cloum_parent_child] = "parent_child"
    sheet1[0,cloum_relationship_type] = "relationship_type"
    sheet1[0,cloum_theme] = "variation_theme"
    sheet1[0,cloum_quantity]= "quantity"
    sheet1[0,cloum_s_price] = "standard_price"
    sheet1[0,cloum_item_name]="item_name"
    sheet1[0,cloum_color] = "color_name"
    sheet1[0,cloum_size] = "size_name"
    sheet1[0,cloum_item_type] = "item_type"
    sheet1[0,cloum_keywords] = "generic_keywords1"
    sheet1[0,cloum_keywords+1] = "generic_keywords2"
    sheet1[0,cloum_keywords+2] = "generic_keywords3"
    sheet1[0,cloum_keywords+3] = "generic_keywords4"
    sheet1[0,cloum_keywords+4] = "generic_keywords5"
    5.times do |f|
      sheet1[0,cloum_points-f] = "bullet_point"+(5-f).to_s
      
    end
    points = points_for album_params[:points]
    points.each_with_index do |f,n|
      sheet1[titlecloum,cloum_points-4+n] = f 
    end
    

    sheet1[titlecloum,cloum_parent_child] = "Parent"
    #sheet1[titlecloum,cloum_relationship_type]= "Variation"
    sheet1[titlecloum,cloum_theme] = "sizecolor"
    sheet1[titlecloum,cloum_upcname] = "UPC"
    sheet1[titlecloum,cloum_brand] = brand
    sheet1[titlecloum,cloum_department] = "womens"
    sheet1[titlecloum,cloum_item_name] = fullname_for(brandname,fullname,"","")

    

    #sheet1[titlecloum,cloum_keywords] = album_params[:keywords].tr("\n",",")

    keywords_arry = album_params[:keywords].tr("\n",",").split(',').uniq.delete_if{|x| !x.to_s.present?}
    

    keywords_uniq = album_params[:keywords].tr("\n"," ").split(' ').uniq.join(' ')[0,1000]
    #album_params[:keywords] = 
    keywords_total = code.length * csize.length * 5+5

    if keywords_type == 1
      if(keywords_arry.length<keywords_total)
        sheet1[titlecloum,cloum_keywords] =  keywords_arry.join(',')
        
      end
    else
      #for keywords 2
      sheet1[titlecloum,cloum_keywords] = keywords_uniq
    end

    
    
    code.each_with_index do |f,n|
      csize.each_with_index do |e,m|
        num = n*csize.length+m+titlecloum+1
        colorname = color_for(f)
        sizename = size_for(e,m,"-", album_params[:ussize])
        
        points.each_with_index do |f,n|
          sheet1[num,cloum_points-4+n] = f 
        end
        sheet1[num,cloum_upcname] = "UPC"
        sheet1[num,cloum_brand]= brand
        sheet1[num,cloum_department]="womens"
        sheet1[num,cloum_parent_sku]= parentsku
        sheet1[num,cloum_parent_child]="Child"
        sheet1[num,cloum_relationship_type]="Variation"
        sheet1[num,cloum_theme]="sizecolor"
        sheet1[num,cloum_quantity]= 50
        sheet1[num,cloum_color]=colorname
        sheet1[num,cloum_size] = sizename
        sheet1[num,cloum_item_name] = fullname_for(brandname,fullname,colorname,sizename.tr("-"," ").tr("/","-"))

        if keywords_type == 1
          if(keywords_arry.length<keywords_total)
            sheet1[num,cloum_keywords] =  keywords_arry.join(',')
            
          end
        else
          #for keywords 2
          sheet1[num,cloum_keywords] =  keywords_uniq
        end
        
        
        
        
        
        
      end
    end


    #设置keywors

    if keywords_type==1
      
      if(keywords_arry.length > keywords_total)
        key_array= keywords_for keywords_total,keywords_arry
        
        sheet1[titlecloum,cloum_keywords] = key_array[0].join(',')
        sheet1[titlecloum,cloum_keywords+1] = key_array[1].join(',')
        sheet1[titlecloum,cloum_keywords+2] = key_array[2].join(',')
        sheet1[titlecloum,cloum_keywords+3] = key_array[3].join(',')
        sheet1[titlecloum,cloum_keywords+4] = key_array[4].join(',')
        
        code.each_with_index do |f,n|
          csize.each_with_index do |e,m|
            num = n*csize.length+m+titlecloum
            sn = (num-1)*5+5

            sheet1[num+1,cloum_keywords] = key_array[sn].join(',')
            sheet1[num+1,cloum_keywords+1] = key_array[sn+1].join(',')
            sheet1[num+1,cloum_keywords+2] = key_array[sn+2].join(',')
            sheet1[num+1,cloum_keywords+3] = key_array[sn+3].join(',')
            sheet1[num+1,cloum_keywords+4] = key_array[sn+4].join(',')
            
          end
        end
      end
      
    else
      #keywords 2
      key_array = keywords_for 4,keywords_arry

      sheet1[titlecloum,cloum_keywords+1] = key_array[0].join(',')[0,1000]
      sheet1[titlecloum,cloum_keywords+2] = key_array[1].join(',')[0,1000]
      sheet1[titlecloum,cloum_keywords+3] = key_array[2].join(',')[0,1000]
      sheet1[titlecloum,cloum_keywords+4] = key_array[3].join(',')[0,1000]

      code.each_with_index do |f,n|
        csize.each_with_index do |e,m|
          num = n*csize.length+m+titlecloum
          
          #sheet1[num+1,cloum_keywords] = key_array[0].join(',')[0,1000]
          sheet1[num+1,cloum_keywords+1] = key_array[0].join(',')[0,1000]
          sheet1[num+1,cloum_keywords+2] = key_array[1].join(',')[0,1000]
          sheet1[num+1,cloum_keywords+3] = key_array[2].join(',')[0,1000]
          sheet1[num+1,cloum_keywords+4] = key_array[3].join(',')[0,1000]
          
        end
      end
      
    end
    

   

    
    
    

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
      params.require(:album).permit(:name, :summary,:csize,:ussize,:brand,:fullname,:dname,:description,:dnote,:keywords,:points)
    end

    def correct_album
      @album = Album.find(params[:id])
      redirect_to(albums_path) unless current_user.albums.include?(@album)
    end
  
end
