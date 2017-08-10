# coding: utf-8
module AlbumsHelper

  def category_for(all)
    result= []
    all.each do |f|
      # result << f.name.upcase.split('0').first
      result << f.name.upcase.scan(/^[A-Z]*/).join('')
    end
    result = result.uniq
  end

 


  def keywords_for(num,keywords)
    
    s= keywords.in_groups(num, false) {|group| p group}
    
  end

  def keywords_for3(num=250,keywords)
    key_length = keywords.tr(" ","").length
    m = key_length / num
    n =  key_length % num
    key_array =  keywords.split(' ')
    s= key_array.in_groups(m+1, false) {|group| p group}
    
    
  end

  def code_for(photos,stylecode)
    code=[]
    strcode = ''
    
    if stylecode.nil? || stylecode.empty?
      stylecode="$$xx"
    end
    n  = stylecode.index("$")
    m = stylecode.scan(/[$]/).length
    #获取颜色分组
    
    photos.each do |f|

      if f.name.length < stylecode.length  
        name = f.name[0,2].downcase
      else
        name = f.name[n,m].downcase
      end
      
      if !strcode.include? name
        strcode += name
        strcode +=" "
        
      end

      
    end
    
    code = strcode.split(' ')
    return code
    
    
  end

  

  def color_map_for(name)
    downname = name.downcase
    case downname
    when "lb","be","na","db","tu"
      "Blue"
    when "re","wr","mr"
      "Red"
    when "bl","bh"
      "Black"
    when "wh"
      "White"
    when "gy","dg"
      "Grey"
    when "gn"
      "Green"
    when "pe"
      "Purple"
    when "ye"
      "Yellow"
    when "pi"
      "Pink"
    when "or"
      "Orange"
    when "br","kh"
      "Brown"
    
      
    else
      "Unknown"
      
    end
  end

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
    else
      "Unknown"
    end 
  end

  def color_for (color)
    case color.downcase
    when "bl"
      "Black"
    when "wh"
      "White"
    when "re"
      "Red"
    when "gn"
      "Green"
    when "gy"
      "Grey"
    when "db"
      "Dark Blue"
    when "ye"
      "Yellow"
    when "be"
      "Blue"
    when "lb"
      "Light Blue"
    when "wr"
      "Red Wine"
    when "db"
      "Dark Blue"
    when "kh"
      "Khaki"
    when "br"
      "Brown"
    when "pi"
      "Pink"
    when "pe"
      "Purple"
    when "na"
      "Navy"
    when "mr"
      "Rose Red"
    when "kh"
      "Khaki"
    when "bh"
      "Black And White"
    when "dg"
      "Dark Green"
    when "tu"
      "Turquoise"
    when "or"
      "Orange"

     
      
    else
      "Unkonwn"
    end

    
  end

  def fullname_for(brand,name,color,size)
    return brand+" "+name+" "+color +" "+ size
  end

  #size for the us
  def size_for(size,n,separate, usszie)
    ob = usszie.split(' ')
    if !usszie.empty? 
      if( ob[n].upcase =~ /[A-Z]$/ )
        return ob[n].upcase
       
      else
        return "US"+separate+ob[n]
      end
    else
      return size.upcase
    end
  end

  def twoarray_for(dsize)
    
    ob = dsize.tr("\n","|").split('|')
    result = Array.new
    ob.each_with_index do |f,n|
      
      result[n]= f.split(' ')
      
    end
    return result
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

  def to_us_size_for(ussize,csize,str)
    ob=ussize 
    if !ussize.empty?
      ob = ussize.split(' ').each_with_index.map {|s,j| s="US "+s+"("+str+csize[j]+")"}
    else
      ob = csize
    end
    return ob
    
  end

  def points_for(points)
    ob = points.tr("\n","|").split('|')
    #ob= points.split('|')
   # if ob.length==1
     # ob = points.split('\n')
    #end
    return ob
  end

  def herf_for(str)
    ob = str.tr("\n","|").split('|')
    
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
  
end
