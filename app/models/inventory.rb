class Inventory < ApplicationRecord
  belongs_to :user
  has_many :stocks, dependent: :destroy
  validates :user_id, presence: true
  validates :sku, presence: true
  validates :pid, presence: true, default: 0
  
end
