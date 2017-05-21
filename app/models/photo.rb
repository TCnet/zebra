# coding: utf-8
class Photo < ApplicationRecord
  belongs_to :album
  mount_uploader :picture, ImgupUploader
  validates :album_id, presence: true
  validate  :picture_size
  validate  :album_size

  private
    # 验证上传的图像大小
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end

    def album_size
      if album_id.to_i < 1
        errors.add(:album_id, "Please select album")
      end
    end
  
end
