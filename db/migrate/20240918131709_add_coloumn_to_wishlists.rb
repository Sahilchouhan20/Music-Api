class AddColoumnToWishlists < ActiveRecord::Migration[7.1]
  def change
    add_column :wishlists, :title, :string
  end
end
