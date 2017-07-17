class InventoriesController < ApplicationController
  include AlbumsHelper

  def new
    @album = Album.find(params[:id])
    @photos = @album.photos
    @inventory = Inventory.new
    @code = code_for(@photos,current_user.imgrule)
    @size = @album.csize.split(' ')
    
  end

  def create
    
    
  end
end
