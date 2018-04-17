# coding: utf-8
module KwordsHelper
  def clear_for(instr,lefwords)
    
    keywords_arry = instr.tr("\n\r","|").split('|').map{|x| x.strip}.uniq.delete_if{|x| !x.to_s.present?}
    lef_arry = lefwords.tr("\n\r","|").split('|').map{|x| x.strip}.uniq.delete_if{|x| !x.to_s.present?}
    s = keywords_arry
   
    lef_arry.each do |n|
      s= s.delete_if{|x| x.to_s.include?(n.to_s.chomp)}
    end
   

    return s.join("\n")
  end
end
