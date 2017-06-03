class PhotosController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: [:destroy]


  
  
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
    album = Album.find(@photo.album_id)
    if album.coverimg == @photo.picture.url(:normal)
      album.coverimg = "nopic.jpg"
      album.save
    end
    @photo.destroy
    flash[:success] = "Photo deleted"
    redirect_to request.referrer || albums_path
  end
  
  private
  def photo_params
    params.require(:photo).permit(:album_id,:picture)
  end
  
  def correct_user
    @photo = Photo.find_by(id: params[:id])
    
    redirect_to albums_path if @photo.album.nil?
  end
end
