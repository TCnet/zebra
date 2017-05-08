class ClearsController < ApplicationController
  def new
  end

  def create
    word=params[:clear][:keywords].downcase
    str=word.split(' ')
    a=[]
    str.each do |d|
      if !a.include?(d)
        a.push(d)
      end
    end
    flash.now[:danger]=str.length.to_s+"|"+a.length.to_s+"|"+a.join(' ')
    render 'new'
  end
end
