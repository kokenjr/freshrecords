require File.expand_path('../../test_helper.rb', __FILE__)

class TestRockstar < Test::Unit::TestCase
  test 'should accept strings' do
    Rockstar.lastfm = {"api_key" => "1234567890", "api_secret" => "0987654321"}
		assert_equal(Rockstar.lastfm_api_key, "1234567890")
		assert_equal(Rockstar.lastfm_api_secret, "0987654321")
  end

	test 'should accept symbols' do
    Rockstar.lastfm = {:api_key => "1234567890", :api_secret => "0987654321"}
		assert_equal(Rockstar.lastfm_api_key, "1234567890")
		assert_equal(Rockstar.lastfm_api_secret, "0987654321")
  end
end
