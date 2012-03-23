desc "Import Records"
task :import_records => :environment do
  require 'amazon/ecs'
  require 'rubygems'
  require 'open-uri'
  require 'nokogiri'

  # Set the default options; options will be camelized and converted to REST request parameters.
  # associate_tag and AWS_access_key_id are required options, associate_tag is required option
  # since API version 2011-08-01. 
  #
  # To sign your request, include AWS_secret_key. 
  Amazon::Ecs.options = {
    :associate_tag => 'vynscrapercom-20',
    :AWS_access_key_id => 'AKIAIMN7BYQJGA5MFUSA',       
    :AWS_secret_key => 'V0C5y+UaB3hpCrIS+0k+s6r+ipivLbO+BdVoeunQ'
  }


  AMZNURL = "http://www.amazon.com"
  AMZNPRODURL = "http://www.amazon.com/s/dp/"
  #amznsearchurl = "http://www.amazon.com/s/ref=sr_st?qid=1330826277&rh=i%3Apopular%2Cn%3A5174%2Cp_n_binding_browse-bin%3A387647011&sort=releasedaterank"
  amznsearchurl = "http://www.amazon.com/s/ref=sr_nr_p_n_binding_browse-b_4?rh=n%3A5174%2Cp_n_binding_browse-bin%3A387647011&bbn=5174&sort=releasedaterank&ie=UTF8&qid=1332431382&rnid=387643011"

  search_asin = []
  index1 = 1
  index2 = 0
  rcount = 1

  while index1 <= 250 do
    #puts "Page number: " + index1.to_s
    vinylsearch = Nokogiri::HTML(open(amznsearchurl))

    vinylsearch.css(".product").each do |prod|
      search_asin[index2] = prod.css(".title .title").attribute('href').text.split('/')[5]
      #puts "ASIN array: " + search_asin.join(',')
      if search_asin.length == 10
        res = Amazon::Ecs.item_lookup(search_asin.join(','), {:response_group => 'Large'})
        puts res.error
        res.items.each do |item|

          item_attributes = item.get_element('ItemAttributes')
          album = item_attributes.get('Title')
          artist = item_attributes.get('Artist').to_s
          genre = item.get('BrowseNodes/BrowseNode/Name')
          if artist.include?('&amp;')
            artist = artist.gsub!('&amp;', '&')
          end
          if album.include?('&amp;')
            album = album.gsub!('&amp;', '&')
          end
          if genre.include?('&amp;')
            genre = genre.gsub!('&amp;', '&')
          end
          if genre == "Styles"
            genre = nil
          end
          price = item.get('OfferSummary/LowestNewPrice/FormattedPrice').to_s.gsub!('$',"").to_f
          date = item_attributes.get('ReleaseDate')
          imagelink = item.get('LargeImage/URL')
          label = item_attributes.get('Label')
          asin = item.get('ASIN')
          produrl = AMZNPRODURL + asin

          puts "Loading Record #" + rcount.to_s
          #puts "artist: " + artist
          #puts "album: " + album
          #puts "ASIN: " + asin
          #puts genre
          #puts "--------------------------------------"
          rcount += 1
          
          record = Record.find_or_create_by_asin(asin)
          record.update_attributes(:name => album, :artist => artist, :price => price, :release_date => date, :image_url => imagelink, :prod_url => produrl, :record_label => label, :genre => genre)

        end
        search_asin = []
        index2 = 0
      else
        index2 += 1
      end
    end

    nextpageurl = AMZNURL + vinylsearch.css("#pagnNextLink").attribute('href')
    amznsearchurl = nextpageurl
    index1 += 1
  end
end
