# coding: utf-8
module ColorCode

  COLORS = %w{KH LK DK BG BL BE LB DB NB SB GB BZ BR CO LC DC CT GD GR AG LN DN GY LG DG MT MC OW OR DO LO RO PI LP DP PE LE DE RE DR LR WR MR SL TT TE WH YE LY DY GM NM KM YM BM LM DM KM iv}

  # color_map
  def color_map_for(name)
    downname = name.downcase
    case downname
    when "kh","lk","dk","bg"
      "Beige"
    when "bl"
      "Black"
    when "be","lb","db","nb","sb","gb"
      "Blue"
    when "bz"
      "Bronze"
    when "br","co","lc","dc","ct"
      "Brown"
    when "gd"
      "Gold"
    when "gr","ag","ln","dn"
      "Green"
    when "gy","lg","dg"
      "Grey"
    when "mt"
      "Metallic"
    when "mc"
      "Multi"
    when "ow"
      "off-white"
    when "or","do","lo","ro"
      "Orange"
    when "pi","lp","dp"
      "Pink"
    when "pe","le","de"
      "Purple"
    when "re","dr","lr","wr","mr"
      "Red"
    when "sl"
      "Silver"
    when "tt"
      "Clear"
    when "wh"
      "White"
    when "te"
      "Turquoise"
    when "ye","ly","dy"
      "Yellow"
    when "gm","nm","km","ym","bm","lm","dm","km"
      "Multi"
    when "iv"
      "Ivory"
      
      
    else
      "Unknown"
      
    end
  end



  #color name
  def color_for (color)
    case color.downcase
    when "kh"
      "Khaki"
    when "lk"
      "Light Khaki"
    when "dk"
      "Deep Khaki"
    when "bg"
      "Beige"
    when "bl"
      "Black"
    when "be"
      "Blue"
    when "lb"
      "Light Blue"
    when "db"
      "Dark Blue"
    when "gb"
      "Grey Blue"
    when "nb"
      "Navy Blue"
    when "sb"
      "Sapphire Blue"
    when "bz"
      "Bronze"
    when "br"
      "Brown"
    when "co"
      "Coffee"
    when "lc"
      "Light Coffee"
    when "dc"
      "Dark Coffee"
    when "ct"
      "Chestnut"
    when "gd"
      "Cold"
    when "gr"
      "Green"
    when "ag"
      "Army Green"
    when "ln"
      "Light Green"
    when "dn"
      "Dark Green"
    when "gy"
      "Grey"
    when "lg"
      "Light Grey"
    when "dg"
      "Dark Grey"
    when "mt"
      "Metallic"
    when "mc"
      "Multicoloured"
    when "ow"
      "Off-White"
    when "or"
      "Orange"
    when "do"
      "Dark Orange"
    when "lo"
      "Light Orange"
    when "ro"
      "Red Orange"
    when "pi"
      "Pink"
    when "lp"
      "Light Pink"
    when "dp"
      "Dark Pink"
    when "pe"
      "Purple"
    when "le"
      "Light Purple"
    when "de"
      "Dark Purple"
    when "re"
      "Red"
    when "dr"
      "Dark Red"
    when "lr"
      "Light Red"
    when "wr"
      "Wine Red"
    when "mr"
      "Rose"
    when "sl"
      "Silver"
    when "tt"
      "Transparent"
    when "te"
      "Turquoise"
    when "wh"
      "White"
    when "ye"
      "Yellow"
    when "ly"
      "Light Yellow"
    when "dy"
      "Dark Yellow"
    when "gm","nm","km","ym","bm","lm","dm","km"
      "Camoflag"
    when "iv"
      "Ivory"
                      
    else
      "Unkonwn"
    end
  end
  #end color
 
end
