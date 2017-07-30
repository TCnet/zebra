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

    num=params[:clear][:numcm]
    scm=num.split(' ')
    acm=[]
    scm.each do |d|
      nd=(d.to_f*0.3937008).round(2).to_s+"\""
      acm.push(nd)
      
    end

    keywords = params[:clear][:keywords]
    keywords_uniq = params[:clear][:keywords].downcase.tr("\n"," ").split(' ').uniq.join(' ')

    flash.now[:success] = keywords_uniq 
    #flash.now[:success]=str.length.to_s+"|"+a.length.to_s+"|"+a.join(' ')
    flash.now[:danger]=num
    flash.now[:info]=acm.join(' ')
    render 'new'
  end
end
