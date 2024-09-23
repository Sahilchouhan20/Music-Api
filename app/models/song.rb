class Song < ApplicationRecord
  validates :name,presence: true
  
  belongs_to :artist
  has_many :wishlists
end
