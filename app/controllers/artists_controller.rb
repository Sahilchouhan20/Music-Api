class ArtistsController < ApplicationController
  before_action :find_artists

  def index
    artists = Artist.all
    render json: { artists: artists }
  end

  def show
    artist = @artists
    render json: { artist: artist }
  end

  def create
    artist = Artist.new(artist_params)
    if artist.save!
      render json:{
        status: {
        code: 200, message: 'Artist Created Succesfully',
        data: artist
      }
      }
    else
      render json:{
        message: "Couldn't find record"
      }, status: :unauthorized
    end
  end

  def update
    if @artist.update(artist_params)
      render json:{
        status: {
        code: 200, message: 'Artists Update',
        data: @artist
      }
      }
    else
      render json:{
        message: 'Artists Not Update',
      }, status: :unauthorized
    end
  end

  def destroy
    if @artist.destroy
      render json:{
        status: {
        code: 200, message: 'Artist Delete Succesfully',
      }
    }
    else
      render json:{
        message: 'Not Delete',
      }, status: :unauthorized
    end
  end

  private

  def artist_params
    params.permit(:name)
  end

  def find_artists
    @artist = Artist.find_by(id: params[:id])
  end
end
