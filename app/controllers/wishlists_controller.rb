class WishlistsController < ApplicationController
  before_action :find_wishlist

  def index
    wishlists = Wishlist.all
    render json:{
        data: wishlists
      }
  end

  def show
    wishlist = @wishlist
    render json:{
        data: wishlist
      }
  end

  def create
    song = Song.find_by(id: params[:song_id])
    user = User.find_by(id: 1)
    wishlist = user.wishlists.new(song_id: song.id)
    if wishlist.save
      render json:{
        status: {
        code: 200, message: 'wishlist created',
        data: wishlist
        }
      }
    else
      render json:{
        message: 'wishlist not created',
      }, status: :unauthorized
    end
  end

  def update
    if @wishlist.update(wishlist_params)
      render json:{
        status: {
        code: 200, message: 'wishlist Update',
        data: @wishlists
        }
      }
    else
      render json:{
        message: 'Wishlist Not Update',
      }, status: :unprocessable_entity
    end
  end

  def destroy
    if @wishlist.destroy
      render json:{
        status: {
        code: 200, message: 'Wishlist Delete',
        }
      }
    else
      render json:{
        message: 'Wishlist Not Delete',
      }, status: :unprocessable_entity
    end
  end

  private

  def wishlist_params
    params.permit(:song_id,:title)
  end

  def find_wishlist
    @wishlist = Wishlist.find_by(id: params[:id])
  end
end
