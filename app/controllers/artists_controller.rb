require 'retriable'
require 'fuzzystringmatch'

class ArtistsController < ApplicationController
  before_action :authenticate_user!

  def index
    @artists = current_user.artists.order("artists.name ASC").paginate(:page => params[:page], :per_page => 25)
    respond_to do |format|
      format.js
      format.html
    end
  end

  def create
    artist_name = params[:artist][:name].downcase
    unless artist_name.blank?
      artist = Artist.where("LOWER(name) LIKE ?", artist_name + "%").first
      if artist
        current_user.artists << artist
      else
        # fuzzy_match = FuzzyStringMatch::JaroWinkler.create( :pure )
        discogs_wrapper = Discogs::Wrapper.new("freshrecords", app_key: ENV["DISCOGS_KEY"], app_secret: ENV["DISCOGS_SECRET"])
        discogs_query = nil
        Retriable.retriable tries: 100, base_interval: 1 do
          discogs_query = discogs_wrapper.search(artist_name, type: "artist")
        end
        discogs_artist = discogs_query.results.first.try(:title)
        # name_distance = 0
        # name_distance = fuzzy_match.getDistance(discogs_artist.title, artist_name) unless discogs_artist.blank?
        # if name_distance >= 0.75
        discogs_artist_name = nil
        discogs_artist_name = discogs_artist.gsub(/\([^)]*\)/,"").strip unless discogs_artist.blank?
        if discogs_artist_name.try(:downcase) == artist_name
          current_user.artists.create(name: discogs_artist_name)
        else
          flash[:danger] = "Could not find Artist"
        end
      end
    end
    redirect_to artists_path
  end

  def destroy
    artist = Artist.find(params[:id])
    current_user.artists.delete(artist)
    redirect_to artists_path, status: 303
  end
end
