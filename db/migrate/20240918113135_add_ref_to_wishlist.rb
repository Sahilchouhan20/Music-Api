class AddRefToWishlist < ActiveRecord::Migration[7.1]
  def change
    add_reference :wishlists, :user, null: false, foreign_key: true
    add_reference :wishlists, :song, null: false, foreign_key: true
  end
end
