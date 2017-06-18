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
    when "gr"
      "Gray"
    when "gn"
      "Green"
    when "pe"
      "Purple"
    when "ye"
      "Yellow"
    when "pi"
      "Pink"
    when "Br"
      "Brown"
    
      
    else
      "Unknown"
      
    end
  end

  def size_for (size)
    case size.downcase
    when "s"
      "Small"
    when "m"
      "Middle"
    when "l"
      "Large"
    when "xl"
      "X-Large"
    when "xxl","2xl"
      "XX-Large"
    when "3xl","xxxl"
      "XXX-Large"
    when "4xl","xxxxl"
      "XXXX-Large"
    when "5xl","xxxxxl"
      "XXXXX-Large"
    else
      "Unknown"
    end
  end
  
end
