# coding: utf-8
class AlbumsController < ApplicationController
 before_action :logged_in_user, only: [:index,:edit,:show, :create, :destroy]
 before_action :correct_album, only: [:show,:edit, :update, :destroy]
 include PhotosHelper
 include AlbumsHelper
 require "spreadsheet"
 Spreadsheet.client_encoding = "UTF-8"  
 
 
  def index
    @albums = current_user.albums.paginate(page: params[:page])
  end

  def new
    @album = Album.new
  end

  def exportexcel
    @album = Album.find(params[:id])
    book = Spreadsheet::Workbook.new
    sheet1 = book.create_worksheet
    sheet1.name = 'Template'
    csize=params["csize"].upcase.split(' ')
    imgcloum=5
    skucloum = 0
    rowheight = 18
    columnwidth = 12
    colormapcloum = 4
    sizemapcloum = 3
    
    

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
    if sizeob
      photos = photos.where("name <>?","size.jpg")

    end
    path= File.join Rails.root, 'public/'

   # @photos.each do |photo|
     # sheet1.row[i,0]= photo.picture.url
     # i= i+1
      
       
      
    # end
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
    
    

    

    
    
    
    
    code=[]
    strcode = ''
    #获取颜色分组
    photos.each do |f|
      name=f.name[0,2].downcase
     

      if !strcode.include? name
        strcode += f.name[0,2]
        strcode +=" "
        
      end

      #phname[:(f.name[0,2])][:(i)]=f.name
      
      #sheet1[1,i] = geturl(f.picture.url)
     
    end
    code = strcode.split(' ')

    # set size_map
    sheet1[0,sizemapcloum] = "Size_map"
    sizenum = csize.length
    code.each_with_index do |f,index|
      if index ==1
      end

      csize.each_with_index do |m,j|
        rownum = index*sizenum +j +2
        sheet1[rownum,sizemapcloum] = size_for(m)
      end
      
    end

    #设置color_map
    sheet1[0,colormapcloum] = "Color_map"
    colornum = csize.length
    code.each_with_index do |f,index|
      if index ==1
      end

      csize.each_with_index do |m,j|
        rownum = index*colornum +j +2
        sheet1[rownum,colormapcloum] = color_for(f)
      end
      
    end
    #设置sku
    
    skunum= csize.length
    code.each_with_index do |n,index|
     
      if index==1
        sheet1.row(1).height = rowheight
        sheet1[1,skucloum] = @album.name.upcase
        
      end
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
    

    

    filename = @album.name+".xls";

    file_path=path+"uploads/export/"+filename

    if File.exist?(file_path)
      File.delete(file_path)
    end
    book.write(file_path)

    
    #flash[:success] = "finished"
    
    File.open(file_path, 'r') do |f|
      send_data f.read.force_encoding('BINARY'), :filename => filename, :type => "application/xls", :disposition => "inline"
    end
    #render :action=> "show" 
    
  end

  def show
    
    @album = Album.find(params[:id])
    photo_url = []
    @album.photos.each do |w|
      photo_url << geturl(w.picture.url)
    end
    @photourls = photo_url.join(' ')
    
   
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
      params.require(:album).permit(:name, :summary)
    end

    def correct_album
      @album = Album.find(params[:id])
      redirect_to(albums_path) unless current_user.albums.include?(@album)
    end
  
end
