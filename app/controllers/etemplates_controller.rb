class EtemplatesController < ApplicationController
  include EtemplatesHelper

  def new
    @etemplate = Etemplate.new
  end

  def create
    @etemplate = current_user.etemplates.build(etemplate_params)
    if @etemplate.save
      flash[:success] = "Template created"
      redirect_to etemplates_path
    else
      render 'new'
    end
  end

  def show
   
    @etemplate = Etemplate.find(params[:id])
    
  end

  def edit
    @etemplate = Etemplate.find(params[:id])
  end

  def destroy
    Etemplate.find(params[:id]).destroy
    flash[:success] = "Template deleted"
    redirect_to etemplates_path
  end

  def update
    @etemplate = Etemplate.find(params[:id])
    if @etemplate.update_attributes(etemplate_params)
      flash[:success] = "Template updated"
      redirect_to etemplates_path
    else
      render 'edit'
    end
    
  end
  #end update

  def index
    @etemplates = current_user.etemplates.order(isused: :desc).order(created_at: :desc).paginate(page: params[:page])
  end
  

  
  private
  
    def etemplate_params
      params.require(:etemplate).permit(:name, :title, :isused)
    end
end
