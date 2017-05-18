class StaticPagesController < ApplicationController
  def home
    @users = User.where(activated: true).order(:id).take(8)
    
    if logged_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])

    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
