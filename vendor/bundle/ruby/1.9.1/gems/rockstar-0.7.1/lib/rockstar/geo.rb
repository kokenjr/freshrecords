module Rockstar
  class Geo < Base
    # Get events in a specific location. Opts can be
    #
    # * :location => 'madrid'  # A city name from geo.metros
    # * :lat => 50.0, :long => 14.0 # A geo point
    #
    # Additionally you can set the distance from that point with
    #   :distance => 50 # 50 km from the given location
    #
    def events(opts = {}, force = false)
      get_instance("geo.getEvents", :events, :event, opts, force)
    end

    def metros(country, force = false)
      get_instance("geo.getMetros", :metros, :metro, {:country => country}, force)
    end


    
    # Get a list of the Top Artists for a specified country
    # 
    # Country is specified in last.fm API docs as 'A country name, as defined by the ISO 3166-1 country names standard'
    # Not sure of the coverage
    # 
    # Also specify limit and page to page through full resultset
    # 
    # returns array of Artist instances
    def topartists(country, limit = nil, page = nil, force = false)
      get_instance("geo.getTopArtists", :topartists, :artist, {:country => country, :limit => limit, :page => page}, force)
    end
    
    # Get a list of the Top Tracks for a specified country
    # 
    # Country is specified in last.fm API docs as 'A country name, as defined by the ISO 3166-1 country names standard'
    # Not sure of the coverage
    # 
    # Also specify limit and page to page through full resultset
    # 
    # returns array of Track instances   
    # TODO: is this the correct object to return? We dont have the full data so is this really best
    def toptracks(country, limit = nil, page = nil, force = false)
      get_instance("geo.getTopTracks", :toptracks, :track, {:country => country, :limit => limit, :page => page}, force)
    end    

  end
end
