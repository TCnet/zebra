class PhotosController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
 # before_action :correct_user, only: [:destroy]

  def index
    @photos = Photo.all
  end

 
  
  def new
    @photo = Photo.new
  end

  def show
    @photo = Photo.find(params[:id])
  end

  def create
    @album = Album.find(params[:photo][:album_id].to_i)
    
    @photo =Photo.create(photo_params)
    if @photo.save
      flash[:success] = "Photo created!"
      #redirect_to albums_path
      redirect_to @album
      
    else
      render 'new'
    end
    
    
    
  end

  def destroy
    id = params[:id]
    id = (params[:photo_ids] || []) if(id == "destroy_multiple")
    #if(id == "")
    #ids = params[:photo_ids] || params[:id]
    if id.nil?||id.empty?
      #flash[:fail] = "id empty"
    else
      @photo = Photo.find(id)
      #@album = Album.find(@photo.first.album_id)

      
      if params[:id]=="destroy_multiple"
        @album = @photo.first.album
      else
        @album = @photo.album
      end

      @album.coverimg = "nopic.jpg"
      @album.save
      
      
      Photo.destroy id if id
      flash[:success] = "Photo deleted"
      redirect_to request.referrer || albums_path
         
    end
  end
  
  

 # def destroy
    #album = Album.find(@photo.album_id)
    #if album.coverimg == @photo.picture.url(:normal)
    #  album.coverimg = "nopic.jpg"
    #  album.save
   # end
   # @photo.destroy
    #flash[:success] = "Photo deleted"
    #redirect_to request.referrer || albums_path
 # end
  
  private
  def photo_params
    params.require(:photo).permit(:album_id,:picture)
  end
  
  def correct_user
    @photo = Photo.find_by(id: params[:id])
    
    redirect_to albums_path if @photo.album.nil?
  end
end
