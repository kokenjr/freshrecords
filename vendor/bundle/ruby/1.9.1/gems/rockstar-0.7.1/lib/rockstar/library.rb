module Rockstar
  class Library < Base

    def artists(force=false, options = {})
      get_instance("library.getArtists", :artists, :artist, options, force)
    end
    
    def albums(force=false, options = {})
      get_instance("library.getAlbums", :albums, :album, options, force)
    end

  end
end
