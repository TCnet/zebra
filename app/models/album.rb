class Album < ApplicationRecord
  include Searchable
  belongs_to :user
  has_many :photos, dependent: :destroy
  default_scope -> {order(created_at: :desc)}
  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 50 }
  
  
end
