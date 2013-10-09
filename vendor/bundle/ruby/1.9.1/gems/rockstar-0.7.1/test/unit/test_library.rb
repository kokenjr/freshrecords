# encoding: utf-8
require File.expand_path('../../test_helper.rb', __FILE__)

class TestLibrary < Test::Unit::TestCase

  def setup
    @library = Rockstar::Library.new
    @user = Rockstar::User.new('jnunemaker')
  end

  test "should be able to get a user's library artists" do
    assert_equal(50, @library.artists(false, { :user => @user.username }).size)
    first = @library.artists(false, { :user => @user.username }).first
    assert_equal('Taylor Swift', first.name)
    assert_equal('20244d07-534f-4eff-b4d4-930878889970', first.mbid)
    assert_equal('1392', first.playcount)
    assert_equal('1', first.rank)
    assert_equal('http://www.last.fm/music/Taylor+Swift', first.url)
    assert_equal('http://userserve-ak.last.fm/serve/34/30883349.png', first.thumbnail)
    assert_equal('http://userserve-ak.last.fm/serve/64/30883349.png', first.image)
  end

  test "should be able to get a user's library artists via wrapper" do
    assert_equal(50, @user.artists.size)
    first = @user.artists.first
    assert_equal('Taylor Swift', first.name)
    assert_equal('20244d07-534f-4eff-b4d4-930878889970', first.mbid)
    assert_equal('1392', first.playcount)
    assert_equal('1', first.rank)
    assert_equal('http://www.last.fm/music/Taylor+Swift', first.url)
    assert_equal('http://userserve-ak.last.fm/serve/34/30883349.png', first.thumbnail)
    assert_equal('http://userserve-ak.last.fm/serve/64/30883349.png', first.image)
  end

  test "should be able to get a user's library albums" do
    assert_equal(50, @library.albums(false, { :user => @user.username }).size)
    first = @library.albums(false, { :user => @user.username }).first
    assert_equal('Dwight Yoakam', first.artist)
    assert_equal('0fb711af-c7ba-4bdc-b0b6-b8495fc0a590', first.artist_mbid)
    assert_equal('The Very Best of Dwight Yoakam', first.name)
    assert_equal('b6a051b4-1a1e-4c33-a1e5-0ea6e920a13f', first.mbid)
    assert_equal('560', first.playcount)
    assert_equal('1', first.rank)
    assert_equal('http://www.last.fm/music/Dwight+Yoakam/The+Very+Best+of+Dwight+Yoakam', first.url)
    assert_equal('http://userserve-ak.last.fm/serve/34s/8725405.jpg', first.image(:small))
    assert_equal('http://userserve-ak.last.fm/serve/64s/8725405.jpg', first.image(:medium))
    assert_equal('http://userserve-ak.last.fm/serve/126/8725405.jpg', first.image(:large))
  end

  test "should be able to get a user's library albums via wrapper" do
    assert_equal(50, @user.albums.size)
    first = @user.albums.first
    assert_equal('Dwight Yoakam', first.artist)
    assert_equal('0fb711af-c7ba-4bdc-b0b6-b8495fc0a590', first.artist_mbid)
    assert_equal('The Very Best of Dwight Yoakam', first.name)
    assert_equal('b6a051b4-1a1e-4c33-a1e5-0ea6e920a13f', first.mbid)
    assert_equal('560', first.playcount)
    assert_equal('1', first.rank)
    assert_equal('http://www.last.fm/music/Dwight+Yoakam/The+Very+Best+of+Dwight+Yoakam', first.url)
    assert_equal('http://userserve-ak.last.fm/serve/34s/8725405.jpg', first.image(:small))
    assert_equal('http://userserve-ak.last.fm/serve/64s/8725405.jpg', first.image(:medium))
    assert_equal('http://userserve-ak.last.fm/serve/126/8725405.jpg', first.image(:large))
  end

end