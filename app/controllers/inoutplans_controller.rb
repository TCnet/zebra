class InoutplansController < ApplicationController
  require "spreadsheet"
  include InoutplansHelper
  Spreadsheet.client_encoding = "UTF-8"
  
  def new
    @inoutplan = Inoutplan.new
  end
  
  

  def index
    @inoutplans = current_user.inoutplans.order(created_at: :desc).paginate(page: params[:page])
  end
  
  def destroy
    #出库
    @inoutplan = Inoutplan.find(params[:id])
    out_stock(@inoutplan,current_warehours)
    @inoutplan.destroy
    flash[:success] = "Inout plan deleted"
    redirect_to inoutplans_path
  end
  
  def edit
    @inoutplan = Inoutplan.find(params[:id])
  end
  
  def update
    @inoutplan =  Inoutplan.find(params[:id])
    #out_stock(@inoutplan,current_warehours)
    out_stock_str(@inoutplan.inout,current_warehours)
    @inoutplan.inoutstocks.each do |d|
      d.delete
    end
    
    if @inoutplan.update_attributes(inoutplan_params)
      
    
      inouts=inoutplan_params["inout"]
      str = twoarray_for(inouts)
      
      str.each_with_index do |f,n|
        p = @inoutplan.inoutstocks.find_by(sku: f[0].upcase)
        if p.nil?
          p = Inoutstock.new
          p.normal= 0
          p.defect= 0
          p.sizeup= 0
          p.sizedown= 0
        end
        
        f.each_with_index do |e,m|
          if(m==0)
             p.sku = e.upcase
           elsif(m==1)
             p.normal= e
           elsif(m==2)
             p.defect= e
           elsif(m==3)
             p.sizeup= e
           elsif(m==4)
             p.sizedown= e
          end
        end
        
        p.inoutplan_id = @inoutplan.id
        p.save
      end
      
      
      in_stock_str(inouts,current_warehours)
      #in_stock(@inoutplan,current_warehours)
      #in_stock(@inoutplan,current_warehours)
      #flash[:success] = inouts.to_s
      flash[:success] = "Inout plan updated"
      redirect_to inoutplans_path
      
    else
      render 'edit'
    end
  end
  
  def show
    @inoutplan = Inoutplan.find(params[:id])
    #@xstocks =Xstock.where("xstockplan_id="+params[:id])
    @inoutstocks = @inoutplan.inoutstocks 
  end
  
  
  def importexcel
    @inoutplan = Inoutplan.find(params[:id])
    #删除之前记录
    out_stock_str(@inoutplan.inout,current_warehours)
    uploader = ExcelUploader.new
    uploader.store!(params[:inoutplan][:excelfile])
    path= File.join Rails.root, 'public/'
    book = Spreadsheet.open (path+ "#{uploader.store_path}")
    sheet1 = book.worksheet 0
    
    sheet1.each 1  do |row|
      p= Inoutstock.find_by(sku: row[0])
      if p.nil?
        p = Inoutstock.new
      end
      p.inoutplan_id = @inoutplan.id
      p.sku = row[0]
      p.normal=row[1].to_i
      p.defect = row[2].to_i
      p.sizeup = row[3].to_i
      p.sizedown = row[4].to_i
      p.actived = row[5]
      
     
      p.save
      
    end
    #入库
    set_inout(@inoutplan)
    
    in_stock_str(@inoutplan.inout,current_warehours)
  
    flash[:success] = "Instocks import!"
    redirect_to inoutplan_path(@inoutplan)
    
  end
  
  def exportexcel
    @inoutplan = Inoutplan.find(params[:id])
    # add format
    book = Spreadsheet::Workbook.new
    sheet1 = book.create_worksheet
    sheet1.name =  @inoutplan.name

    format = Spreadsheet::Format.new :size => 11,
                                     :vertical_align => :middle,
                                     :border => :thin,
                                     :pattern_fg_color => :yellow,
                                     :pattern => 1
    
    sheet1.row(0).default_format = format
    sheet1.row(0).height = 30
    sheet1.column(0).width =15
    title = %w(SKU Normal Defect Sizeup Sizedown Actived)
    title.each_with_index do |n,index|
      sheet1[0,index] = n     
    end
            
    @inoutstocks = @inoutplan.inoutstocks

    @inoutstocks.each_with_index do |ob,index|
      
      sheet1[index+1,0]= ob.sku
      sheet1[index+1,1]= ob.normal
      sheet1[index+1,2]= ob.defect
      sheet1[index+1,3]= ob.sizeup
      sheet1[index+1,4]= ob.sizedown
      sheet1[index+1,5]= ob.actived
      
     
    end
                 


    
    path= File.join Rails.root, 'public/'

    #create excel
    filename = @inoutplan.name+".xls";

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
    @inoutplan = current_user.inoutplans.build(inoutplan_params)
  
    if @inoutplan.save

      str = twoarray_for(inoutplan_params["inout"])
      str.each_with_index do |f,n|
        p = Inoutstock.new
        p.normal= 0
        p.defect= 0
        p.sizeup= 0
        p.sizedown= 0
        
        f.each_with_index do |e,m|
          if(m==0)
             p.sku = e.upcase
           elsif(m==1)
             p.normal= e
           elsif(m==2)
             p.defect= e
           elsif(m==3)
             p.sizeup= e
           elsif(m==4)
             p.sizedown= e
          end  
          
        end
        p.inoutplan_id = @inoutplan.id
        p.save
        
      end
      
      #in_stock(@inoutplan,current_warehours)
      in_stock_str(inoutplan_params["inout"],current_warehours)
      flash[:success] = "stock plan created!"
      redirect_to inoutplans_path
      
    else
      render 'new'
    end
  end

  private
  
    def inoutplan_params
      params.require(:inoutplan).permit(:name, :inout, :actived)
    end
  

end
