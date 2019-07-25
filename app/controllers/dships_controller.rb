class DshipsController < ApplicationController
  before_action :logged_in_user
  require "spreadsheet"
  Spreadsheet.client_encoding = "UTF-8"  
  
  include AlbumsHelper
  include DshipsHelper
  include ExportEub
  
  def index
    @dships=current_user.dships.where("tracknum is null and price is null ").order(created_at: :desc).paginate(page: params[:page])
  end
  
  def check
    @dships=current_user.dships.where("tracknum <> '' and price is null ").order(created_at: :desc).paginate(page: params[:page])
    render 'dship_check'
  end
  
  def finish
    @dships=current_user.dships.where("tracknum <> '' and price is not null ").order(created_at: :desc).paginate(page: params[:page])
    render 'dship_finish'
  end

  def show
    @dship = Dship.find(params["id"])
    
  end
  
    
  def outexcel
   
    
    #id = params[:id]
    #id = (params[:album_ids] || []) if(id == "out_multiple")
    id = params[:dship_ids]
    path= File.join Rails.root, 'public/'
    etemplate= get_eubtemplate current_user
    skutemp = get_eub_skutemplate current_user
    filename = "EUB_"+Time.now.strftime('%Y-%m-%d')
    #flash[:sucess] = obs.first.name
    if(id.nil?||id.empty?)
      flash[:danger] = "Please select dship first!"
      redirect_to dships_path
    else
      obs= Dship.find id
      if(obs.nil?||obs.empty?)
        flash[:danger] = "Please check dship exist!"
        redirect_to dships_path
      else
        outeub obs,etemplate,skutemp,path,current_user,filename
      end
    end
    
    
  end


def new
  @dship= Dship.new
end

def create
  save_import
end

def save_import
  uploader = ExcelUploader.new 
  uploader.store!(params[:dship][:excelfile])
  path= File.join Rails.root, 'public/'

  #book = Spreadsheet.open (path+'/uploads/upcs/upc_test.xls')
  #Spreadsheet.open('~/upc_test.xlsx', 'r')
  book = Spreadsheet.open (path+ "#{uploader.store_path}")
    
   
  sheet1 = book.worksheet 0
   
    
  sheet1.each 1  do |row|
    ordernum = row[0]
    p= Dship.find_by(ordernum: ordernum)
    if !p
      p = Dship.new
      p.user_id =  current_user.id
      p.ordernum = ordernum
    end

    p.dealnum = row[1]
    
    p.sku=  row[2]
    p.num = row[3]
    p.name=row[4]
    p.address1= row[5]  
    p.address2= row[6]
    p.address3= row[7]
    p.city= row[8]
    p.state= row[9]
    p.zip= row[10]
    p.country= row[11]
    p.phone= row[12]
    p.email= row[13]
    p.customize= row[14]
    p.remark= row[15]
    p.source= row[16]
    p.tracknum = row[17]
    p.weight = row[18]
    p.price = row[19]
    p.sender = row[20]
    p.excelfile = uploader.filename
    p.save
     
  end

  uploader.remove!
  redirect_to dships_path
end

def destroy
  Dship.find(params[:id]).destroy
  flash[:success] = "Dship deleted"
  redirect_to dships_url
end
  
end
