module SizeCode

  #size_map
  def size_map_for (size)
    case size.downcase
    when "xs","26"
      "X-Small"
    when "s","28"
      "Small"
    when "m", "29"
      "Medium"
    when "l", "30"
      "Large"
    when "xl", "31"
      "X-Large"
    when "xxl","2xl", "32"
      "XX-Large"
    when "3xl","xxxl", "34"
      "XXX-Large"
    when "4xl","xxxxl", "36"
      "XXXX-Large"
    when "5xl","xxxxxl","38"
      "XXXXX-Large"
    when "f"
      "X-Large"
    when "tm"
      "Large"
    else
      "Unknown"
    end 
  end
  #end size map

  #size for the us
  def size_for(size,n,separate, usszie)
    ob = usszie.split(' ')
    if !usszie.empty? 
      if( ob[n].upcase =~ /[A-Z]$/ )
        return ob[n].upcase
        
      else
        return "US"+separate+ob[n]
      end
    elsif(size.downcase=="tm")
      return "One Size"
    else
      return size.upcase
    end
  end
  #end size_for

  def to_us_size_for(ussize,csize,str)
    ob=ussize 
    if !ussize.empty?
      ob = ussize.split(' ').each_with_index.map {|s,j| s="US "+s+"("+str+csize[j]+")"}
    else
      ob = csize
    end
    return ob
    
  end

  def to_in(cm,is_in)
    result = ''
    str = cm.to_s.split('-')
    str.each_with_index do |f,e|
      if is_in
        result +=f.to_s+"\""
      else
        strcm= f.to_s
        #   result += (f.to_s.to_f*0.3937008).round(2).to_s+"\""
        strcm=(strcm.to_f*0.3937008).round(2).to_s
        result +=strcm+"\""
      end
      if e<str.length-1
        result += "-"
      end
      
    end
    return result
  end


  def description_size_for(desize,csize,is_in=false)
    #set size for description
    destr=""
    
    if !desize.empty?
      dearray = twoarray_for desize
      csizelen = csize.length
      csize.each_with_index do |f,num|
        destr += f;
        destr +=": "

        dellen = dearray[0].length
        
        dellen.times do |e|
          
          destr += dearray[0][e]
          destr +=" "
          dearray.length.times do |c|
            if c > 0&& c-1==e
              
              destr += to_in(dearray[c][num],is_in)
              
            end
          end
          if e==dellen-1
            destr +="."
          else
            destr +=","
          end
          
        end
        
        
        destr+="<br>"
        destr +="\n"
        
      end    
      
    end

    return destr
    
  end
  #end dericript size
  

  

  

  
  
end
