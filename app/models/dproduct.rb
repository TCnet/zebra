class Dproduct < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :sku, presence: true
end
