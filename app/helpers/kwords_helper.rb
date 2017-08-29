# coding: utf-8
module KwordsHelper
  def clear_for(instr,lefwords)
    keywords_arry = instr.tr("\n","|").split('|').uniq.delete_if{|x| !x.to_s.present?}
    lef_arry = lefwords.tr("\n","|").split('|').uniq.delete_if{|x| !x.to_s.present?}

   
    lef_arry.each do |n|
      keywords_arry=  keywords_arry.delete_if{|x| x.to_s.include?(n.to_s.chomp)}
    end
   

    return keywords_arry.join('')
  end
end
