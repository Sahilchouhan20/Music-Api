class SongsController < ApplicationController
  before_action :find_songs

  def index
    songs = Song.all
    render json:{
        data: songs
      }
  end

  def show
    song = @song
    render json:{
        data: song
      }
  end

  def create
    @artist = Artist.find_by(id: params[:artist_id])
    @song = @artist.songs.new(song_params)
    if @song.save!
      render json:{
        status: {
        code: 200, message: 'Song created successfully',
        data: @song
        }
      }
    else
      render json:{
        message: 'Song not created',
      }, status: :unprocessable_entity
    end
  end

  def update
    if @song.update(song_params)
      render json:{
        status: {
        code: 200, message: 'Song Changed',
        data: @song
       }
      }
    else
      render json:{
        message: 'Song Not Update',
      }, status: :unauthorized
    end
  end

  def destroy
    if @song.destroy
      render json:{
        status: {
        code: 200, message: 'Song Delete',
      }
      }
    else
      render json:{
        message: 'Song Not Delete',
      }, status: :unauthorized
    end
  end

  private

  def song_params
    params.permit(:name)
  end

  def find_songs
    @song = Song.find_by(id: params[:id])
  end
end
