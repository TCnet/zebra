class Xstockplan < ApplicationRecord
  belongs_to :user
  has_many :xstocks, dependent: :destroy
  validates :name, presence: true, length: { maximum: 50 },
            uniqueness: { case_sensitive: false }
end
