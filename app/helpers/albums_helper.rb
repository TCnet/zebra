# coding: utf-8
module AlbumsHelper


  def color_for(name)
    downname = name.downcase
    case downname
    when "lb","be","na"
      "Blue"
    when "re","wr"
      "Red"
    when "bl"
      "Black"
    when "wh"
      "White"
    when "gy"
      "Gray"
    when "gn"
      "Green"
    when "pe"
      "Purple"
    when "ye"
      "Yellow"
    when "pi"
      "Pink"
    when "br","ka"
      "Brown"
    
      
    else
      "Unknown"
      
    end
  end

  def size_for (size)
    case size.downcase
    when "s","28"
      "Small"
    when "m", "29"
      "Middle"
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
    else
      "Unknown"
    end 
  end

  def twoarray_for(dsize)
    
    ob = dsize.split('|')
    result = Array.new
    ob.each_with_index do |f,n|
      
      result[n]= f.split(' ')
      
    end
    return result
  end

  def to_in(cm)
    (cm.to_f*0.3937008).round(2).to_s+"\""
  end

  def to_us_size_for(ussize,csize,str)
    ob=ussize 
    if !ussize.empty?
      ob = ussize.split(' ').each_with_index.map {|s,j| s="US "+s+"("+str+csize[j]+")"}
    else
      ob = csize
    end
    return ob
    
  end


  def description_size_for(desize,csize)
    #set size for description
    dearray = twoarray_for desize
    destr=""
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
            destr += to_in(dearray[c][num])
            
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

    return destr
    
  end
  
end
