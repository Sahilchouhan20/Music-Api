class Wishlist < ApplicationRecord
  validates :title, presence: true
  
  belongs_to :user
  belongs_to :song
end
