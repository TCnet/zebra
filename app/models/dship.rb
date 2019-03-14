class Dship < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :ordernum, presence: true, uniqueness: { case_sensitive: false }
  
  
end
