# coding: utf-8
module ApplicationHelper
  def full_title(page_title = '')
    
  # 根据所在的页面返回完整的标题 def full_title(page_title = '')
    base_title = "BBS only for nbtcnet friends"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end


end
