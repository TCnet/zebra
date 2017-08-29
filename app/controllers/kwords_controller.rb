class KwordsController < ApplicationController
  include AlbumsHelper
  include KwordsHelper

  def new
    @kword = Kword.new
  end

  def create
    @kword = current_user.kwords.build(kword_params)
    @kword.outstr =clear_for kword_params[:instr],kword_params[:lefwords]
    if @kword.save
      flash[:success] = "Kword created!"
      redirect_to kwords_path
      
    else
      render 'new'
    end
  end

  def show
    @category = category_for current_user.kwords
    @kword = Kword.find(params[:id])
    
  end

  def edit
    @kword = Kword.find(params[:id])
   
  end

  def destroy
    Kword.find(params[:id]).destroy
    flash[:success] = "Kwords deleted"
    redirect_to kwords_path
  end

  def update
    @kword = Kword.find(params[:id])
   # kword_params[:outstr] = "new out"
    @kword.outstr =clear_for kword_params[:instr],kword_params[:lefwords]
    if @kword.update_attributes(kword_params)
      flash[:success] = "Kwords updated"
      redirect_to kwords_path
    else
      render 'edit'
    end
  end
  

  def index
    @category = category_for current_user.kwords
    
    sql = "name LIKE ?"
    #condition = params[:q].nil? "":"name like \%"+params[:q]+"\%"
   # @kwords = current_user.kwords.where(sql,"%#{params[:q]}%").paginate(page: params[:page])
    # @albums = current_user.albums.search(params[:q]).paginate(page: params[:page])
   # @kwords = current_user.kwords.all

    @kwords=current_user.kwords.paginate(page: params[:page])
  end
    

  private
  
    def kword_params
      params.require(:kword).permit(:name, :instr,:lefwords)
    end

  
  
end
