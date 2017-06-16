class UpcsController < ApplicationController
  require "spreadsheet"
  Spreadsheet.client_encoding = "UTF-8"  
  
  def index
    @upcs=current_user.upcs.paginate(page: params[:page])
  end

  def show
    @upc = Upc.find(params["id"])
  end

  def new
    @upc= Upc.new
  end

  def create
    save_import
  end

  def save_import
    uploader = ExcelUploader.new 
    uploader.store!(params[:upc][:excelfile])
    path= File.join Rails.root, 'public/'

    #book = Spreadsheet.open (path+'/uploads/upcs/upc_test.xls')
    #Spreadsheet.open('~/upc_test.xlsx', 'r')
    book = Spreadsheet.open (path+ "#{uploader.store_path}")
    
   
    sheet1 = book.worksheet 0
   
    
    sheet1.each 0  do |row|
      p = Upc.new
      p.user_id =  current_user.id
      p.name = row
      p.excelfile = uploader.filename
      p.save
     
    end

    uploader.remove!
    redirect_to upcs_path
  end

  def destroy
    Upc.find(params[:id]).destroy
    flash[:success] = "Upc deleted"
    redirect_to upcs_url
  end
  
end
