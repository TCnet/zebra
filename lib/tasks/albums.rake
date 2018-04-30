# coding: utf-8
# lib/tasks/albums.rake
namespace :albums do
  task :set_nil => :environment do
    Album.all.each do |ob|
      Album.content_columns.each do |ee|
        if(ob[ee.name].nil?)
          ob[ee.name] = " "
        end
        
                
      end
     
      ob.save
     
    end
  end
end
