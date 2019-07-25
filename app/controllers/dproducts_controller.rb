class DproductsController < ApplicationController
  before_action :logged_in_user
  require "spreadsheet"
  Spreadsheet.client_encoding = "UTF-8"  
  
  include AlbumsHelper
  include DproductsHelper
  include ExportDproduct
  
  def index
    @dproducts=current_user.dproducts.paginate(page: params[:page])
  end

  def show
    @dproduct = Dproduct.find(params["id"])
    album = Album.find_by(name: @dproduct.sku)
    @coverimg = ""
    @herf = []
    if album!=nil
      @coverimg = album.coverimg
      
      @herf = herf_for album.summary
    end
    
  end

  def new
    @dproduct= Dproduct.new
  end
  
  def outexcel

    #id = params[:id]
    #id = (params[:album_ids] || []) if(id == "out_multiple")
    id = params[:dproduct_ids]
    path= File.join Rails.root, 'public/'
    etemplate= get_dproduct_template current_user
    
    filename = "pro_"+Time.now.strftime('%Y-%m-%d')
    #flash[:sucess] = obs.first.name
    if(id.nil?||id.empty?)
      flash[:danger] = "Please select dproduct first!"
      redirect_to dproducts_path
    else
      obs= Dproduct.find id
      if(obs.nil?||obs.empty?)
        flash[:danger] = "Please check dship exist!"
        redirect_to dproducts_path
      else
        outdproduct obs,etemplate,path,current_user,filename
      end
    end
    
    
  end
  

  def create
    save_import
  end

  def save_import
    uploader = ExcelUploader.new 
    uploader.store!(params[:dproduct][:excelfile])
    path= File.join Rails.root, 'public/'

    #book = Spreadsheet.open (path+'/uploads/upcs/upc_test.xls')
    #Spreadsheet.open('~/upc_test.xlsx', 'r')
    book = Spreadsheet.open (path+ "#{uploader.store_path}")
    
   
    sheet1 = book.worksheet 0
   
    
    sheet1.each 1  do |row|
      sku = row[0].upcase
      p= Dproduct.find_by(sku: sku)
      if !p
        p = Dproduct.new
        p.user_id =  current_user.id
        p.sku = sku
      end

      p.name = row[1]
      p.parent=row[5]
      p.cname=  row[2]
      p.dprice = row[4]
      p.depotid=0
      p.weight= row[3]  
      p.save
     
    end

    uploader.remove!
    redirect_to dproducts_path
  end

  def destroy
    Dproduct.find(params[:id]).destroy
    flash[:success] = "Dproduct deleted"
    redirect_to dproducts_url
  end
  
end
