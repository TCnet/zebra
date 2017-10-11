class XstockplansController < ApplicationController
  require "spreadsheet"
  include XstockplansHelper
  Spreadsheet.client_encoding = "UTF-8"
  
  def index
    @xstockplans = current_user.xstockplans.paginate(page: params[:page])
  end

  def new
    @xstockplan = Xstockplan.new
  end
  
  def destroy
    Xstockplan.find(params[:id]).destroy
    flash[:success] = "Stock plan deleted"
    redirect_to xstockplans_path
  end

  def edit
    @xstockplan = Xstockplan.find(params[:id])
  end

  def update
    @xstockplan =  Xstockplan.find(params[:id])
    if @xstockplan.update_attributes(xstockplan_params)
      flash[:success] = "stock plan updated"
      redirect_to xstockplans_path
    else
      render 'edit'
    end
  end

  def show
    @xstockplan = Xstockplan.find(params[:id])
    #@xstocks =Xstock.where("xstockplan_id="+params[:id])
    @xstocks = @xstockplan.xstocks
  end

  def importexcel
    @xstockplan = Xstockplan.find(params[:id])
    uploader = ExcelUploader.new
    uploader.store!(params[:xstockplan][:excelfile])
    path= File.join Rails.root, 'public/'
    book = Spreadsheet.open (path+ "#{uploader.store_path}")
    sheet1 = book.worksheet 0
    
    sheet1.each 1  do |row|
      p= Xstock.find_by(sku: row[0])
      if p.nil?
        p = Xstock.new
      end
      p.xstockplan_id = @xstockplan.id
      p.sku = row[0]
      p.fnsku=row[1]
      p.parentsku = row[2]
      p.homenum = row[3].to_i
      p.fbanum = row[4].to_i
      p.monthsold = row[5].to_i
      p.plannum = row[6].to_i
      p.name =row[7]
     
      
     
      p.save
      
    end
  
    flash[:success] = "stocks import!"
    redirect_to xstockplan_path(@xstockplan)
    
  end

  def exportexcel
    @xstockplan = Xstockplan.find(params[:id])
    # add format
    book = Spreadsheet::Workbook.new
    sheet1 = book.create_worksheet
    sheet1.name =  @xstockplan.name

    format = Spreadsheet::Format.new :size => 11,
                                     :vertical_align => :middle,
                                     :border => :thin,
                                     :pattern_fg_color => :yellow,
                                     :pattern => 1
    
    sheet1.row(0).default_format = format
    sheet1.row(0).height = 30
    sheet1.column(0).width =15
    title = %w(SKU FNSKU ParentSKU HomeNum FBANum 30daysSold PlanNum Name ShouldBuy)
    title.each_with_index do |n,index|
      sheet1[0,index] = n     
    end
            
    @xstocks = @xstockplan.xstocks

    @xstocks.each_with_index do |ob,index|
      stock_num = for_stock_num(ob.homenum,ob.fbanum,ob.monthsold,2,ob.plannum)
      sheet1[index+1,0]= ob.sku
      sheet1[index+1,1]= ob.fnsku
      sheet1[index+1,2]= ob.parentsku
      sheet1[index+1,3]= ob.homenum
      sheet1[index+1,4]= ob.fbanum
      sheet1[index+1,5]= ob.monthsold
      sheet1[index+1,6]= ob.plannum
      sheet1[index+1,7]= ob.name
      sheet1[index+1,8]=stock_num
    end
                 


    
    path= File.join Rails.root, 'public/'

    #create excel
    filename = @xstockplan.name+".xls";

    file_path=path+"uploads/export/"+filename

    if File.exist?(file_path)
      File.delete(file_path)
    end
    book.write(file_path)
    File.open(file_path, 'r') do |f|
      send_data f.read.force_encoding('BINARY'), :filename => filename, :type => "application/xls", :disposition => "inline"
    end
    
  end
  
  
  

  def create
    @xstockplan = current_user.xstockplans.build(xstockplan_params)
  
    if @xstockplan.save
      flash[:success] = "stock plan created!"
      redirect_to xstockplans_path
      
    else
      render 'new'
    end
  end

  private
  
    def xstockplan_params
      params.require(:xstockplan).permit(:name)
    end

  
end
