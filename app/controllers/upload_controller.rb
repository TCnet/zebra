class UploadController < ApplicationController
  def create
    photo = Photo.new
    photo.name = params[:qqfilename]
    photo.qquuid = params[:qquuid]
    photo.picture = params[:qqfile]
    photo.album_id= params[:album_id]
    album = Album.find(params[:album_id])
   

    if photo.save
      if album.coverimg == "nopic.jpg"
        album.coverimg = photo.picture.url(:normal)
        album.save
      end
      respond_to do |format|
        format.json {
          render json: { success: true }
        }
        
      end
    else
      respond_to do |format|
        format.json {
          render json: { errors: 'Something went wrong'}
        }
      end
    end
  end

  def destroy
    photo = Photo.find_by(qquuid: params[:qquuid])
    if photo.destroy
      respond_to do |format|
        format.json {
          render json: { success: true }
        }
      end
    end
  end

  def finish
    # Grab all parts of photo
    photos = Photo.where(qquuid: params[:qquuid]).all
    # Combine all parts
    @photo = Photo.combine_photos(photos)

    if @photo.save
      
      respond_to do |format|
        format.json {
          render json: { success: true }
        }
      end
    end
  end

  private
  
  
    def correct_user
      @photo = Photo.find_by(id: params[:id])
    
      redirect_to albums_path if @photo.album.nil?
    end

  # Use callbacks to share common setup or constraints between actions.
    def set_photo
      @photo = Photo.find(params[:id])
    end

  # Never trust parameters from the scary internet, only allow the white list through.
    def photo_params
      params.require(:photo).permit(:name, :qquuid, :picture, :album_id)
    end
  
end
