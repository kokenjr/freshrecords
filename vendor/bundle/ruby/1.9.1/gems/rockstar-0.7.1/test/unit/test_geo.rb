require File.expand_path('../../test_helper.rb', __FILE__)

class TestGeo < Test::Unit::TestCase
  
  test "should get events in london" do
    geo = Rockstar::Geo.new
    events = geo.events({:location => 'london'})
  
    assert_equal(10, events.size)
    assert_equal("Basement Scam", events.first.title)
    assert_equal("Buffalo Bar", events.first.venue.name)
    assert_equal("London", events.first.venue.city)
  end

  test "get cities for a country" do
    geo = Rockstar::Geo.new

    metros = geo.metros("germany")
    assert_equal(10, metros.size)
    assert_equal("Bremen", metros.first.name)
    assert_equal("Germany", metros.first.country)
  end
  
  test "should get top artists for a country" do
    limit = 50 #the mock resultset has 50 in so just fake this
    
    geo = Rockstar::Geo.new
    
    artists = geo.topartists("spain", limit)
    assert_equal(limit, artists.size)
    assert_equal("Muse", artists.first.name)
    assert_equal("1695c115-bf3f-4014-9966-2b0c50179193", artists.first.mbid)
    assert_equal('1736', artists.first.listenercount)
    
  end
  
  test "should get top tracks for a country" do
    limit = 50 #the mock resultset has 50 in so just fake this
    
    geo = Rockstar::Geo.new
    
    tracks = geo.toptracks("spain", limit)
    assert_equal(limit, tracks.size)
    assert_equal("Diamonds", tracks.first.name)
    assert_equal("Rihanna", tracks.first.artist)
    assert_equal("f281056d-5696-43d0-bb2e-61677ef65309", tracks.first.mbid)
    
  end  
  

end
