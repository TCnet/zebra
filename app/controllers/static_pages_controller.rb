class StaticPagesController < ApplicationController

  include AlbumsHelper

  
  def home
    @users = User.where(activated: true).order(:id).take(8)
    
    if logged_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])

    end
  end

  def help
    @colors = COLORS
  end

  def about
  end

  def contact
  end
end
