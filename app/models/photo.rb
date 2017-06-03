# coding: utf-8
class Photo < ApplicationRecord
  belongs_to :album
  mount_uploader :picture, ImgupUploader
  validates :album_id, presence: true
  validate  :picture_size
  validate  :album_size

  def self.combine_photos(photos)
    # =>  Convert the carrierwave attachment(image)
    files = photos.map{|p| p.image.file.to_file}
    orginal_filename = photos.first.name

    # => Create a new file
    new_file = File.open(orginal_filename, 'w')

    # => Save information from parted files into the new one
    files.each do |file|
      text = File.open(file, 'r').read
      text.each_line do |line|
        new_file << line.chomp + "\n"
      end
    end

    # => Create new photo's object with the combined file
    final_photo = Photo.new
    final_photo.name = orginal_filename
    final_photo.image = new_file

    # => Remove all parts of the image
    photos.destroy_all

    return final_photo
  end

  private
    # 验证上传的图像大小
    def picture_size
      if picture.size > 1.megabytes
        errors.add(:picture, "should be less than 1MB")
      end
    end

    def album_size
      if album_id.to_i < 1
        errors.add(:album_id, "Please select album")
      end
    end
  
end
