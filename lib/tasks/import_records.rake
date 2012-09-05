desc "Import Records"
task :import_records => :environment do
  require 'amazon/ecs'
  require 'rubygems'
  require 'open-uri'
  require 'nokogiri'
  require 'progress_bar'

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
  TOTALPAGES = 250
  #amznsearchurl = "http://www.amazon.com/s/ref=sr_st?qid=1330826277&rh=i%3Apopular%2Cn%3A5174%2Cp_n_binding_browse-bin%3A387647011&sort=releasedaterank"
  amznsearchurl = "http://www.amazon.com/s/ref=sr_nr_p_n_binding_browse-b_4?rh=n%3A5174%2Cp_n_binding_browse-bin%3A387647011&bbn=5174&sort=releasedaterank&ie=UTF8&qid=1332431382&rnid=387643011"

  search_asin = []
  index1 = 1
  index2 = 0
  rcount = 1
  #progress_bar = ProgressBar.new(TOTALPAGES, :percentage, :eta)

  while index1 <= TOTALPAGES do
    #progress_bar.increment!
    puts "Progress: [ " + '%.2f' % ((index1.to_f/TOTALPAGES.to_f)*100) + "%]"

    vinylsearch = Nokogiri::HTML(open(amznsearchurl))

    vinylsearch.css(".product").each do |prod|
      search_asin[index2] = prod.css(".title .title").attribute('href').text.split('/')[5]
      if search_asin.length == 10
        res = Amazon::Ecs.item_lookup(search_asin.join(','), {:response_group => 'Large'})
        #puts res.error
        res.items.each do |item|

          item_attributes = item.get_element('ItemAttributes')
          album = item_attributes.get('Title').gsub('&amp;', '&')
          artist = item_attributes.get('Artist').to_s.gsub('&amp;', '&')
          genre = item.get('BrowseNodes/BrowseNode/Name').gsub('&amp;', '&')
          
          if genre == "Styles"
            genre = nil
          end
          
          price = item.get('OfferSummary/LowestNewPrice/FormattedPrice').to_s.gsub('$',"").to_f
          date = item_attributes.get('ReleaseDate')
          imagelink = item.get('LargeImage/URL')
          label = item_attributes.get('Label')
          asin = item.get('ASIN')
          produrl = AMZNPRODURL + asin + "?tag=vynscrapercom-20"

          #puts "Loading Record #" + rcount.to_s
          #puts "artist: " + artist
          #puts "album: " + album
          #puts "ASIN: " + asin
          #puts "Image URL: " + imagelink.to_s
          #puts genre
          #puts "--------------------------------------"
          rcount += 1

          if imagelink == nil || imagelink.include?('41kG2tg40sL')    
            record = Record.find_or_create_by_asin(asin)
            record.update_attributes(:name => album, :artist => artist, :price => price, :release_date => date, :prod_url => produrl, :record_label => label, :genre => genre)
          else
            record = Record.find_or_create_by_asin(asin)
            record.update_attributes(:name => album, :artist => artist, :price => price, :release_date => date, :image_url => imagelink, :prod_url => produrl, :record_label => label, :genre => genre)
          end

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
  puts "Total Records Loaded = " + rcount.to_s
end

desc "Fetch Album Art"
task :fetch_albumart => :environment do
  require 'rubygems'
  require 'open-uri'
  require 'nokogiri'
  require 'levenshtein'
  require 'progress_bar'

  amzn_music_search_url = "http://www.amazon.com/s/ref=nb_sb_noss?url=search-alias%3Dpopular&field-keywords="
  #amzn_music_search_url = "http://www.amazon.com/s/ref=nb_sb_noss?url=search-alias%3Daps&field-keywords="
  count = 1

  #progress_bar = ProgressBar.new(Record.find_all_by_image_url(nil).count, :percentage, :eta)

  Record.find_all_by_image_url(nil).each do |record|
  #Record.find_all_by_asin("B007KKJ59U").each do |record|
    #progress_bar.increment!
    puts "Progress: [ " + '%.2f' % ((count.to_f/Record.find_all_by_image_url(nil).count.to_f)*100) + "%]"
    
    image_link = record.image_url
    
    record_page = Nokogiri::HTML(open(record.prod_url))
    record_page.css(".noLinkDecoration a").each do |rp|
      if rp.attribute("href").text.include?("http")
        rp_page = Nokogiri::HTML(open(rp.attribute("href").text))
        if rp_page.css("#prodImage").empty? == false && rp_page.css("#prodImage").attribute("src").text.include?("no-image") == false
          image_link = rp_page.css("#prodImage").attribute("src").text.gsub('._SL500_AA280_','')
          #puts "scraped method 1"
          break
        else
          image_link = nil
        end
      else
        image_link = nil
      end
    end
  
    if image_link == nil
      image_search = Nokogiri::HTML(open(amzn_music_search_url + CGI::escape(record.artist + " " + record.name)))
      image_search.css(".product").each do |prod|
        prod_title = prod.css(".title .title").text.downcase.gsub(",","")
        record_title = record.name.downcase.gsub(",","")
        prod_artist = prod.css(".ptBrand").text.downcase.gsub("by ","")
        record_artist = record.artist.downcase

        if prod.css(".productImage").empty? == false && prod.css(".productImage").attribute("src").text.include?('41kG2tg40sL') == false && (prod_artist.include?(record_artist) || record_artist.include?(prod_artist)) && (prod_title.include?(record_title) || Levenshtein.distance(prod_title,record_title) <= 2 || record_title.include?(prod_title))
          image_link = prod.css(".productImage").attribute("src").text.gsub('._AA115_','').gsub('._AA160_','')
          #puts "scraped method 2"
          break
        else
          image_link = nil
        end
      end
    end

    #puts "Updating art for: " + record.asin + " #" + count.to_s
    record.update_attributes(:image_url => image_link)
    count += 1
  end
end

desc "Lastfm data"
task :fetch_lastfm => :environment do
  require 'rockstar'
  require 'progress_bar'
  
  Rockstar.lastfm = {:apii_key => "7c58f1848c6ad8ff32cf07fb7e978d7b", :api_secret => "76900414f897ba5c201bba7acb71e72f"}
  progress_bar = ProgressBar.new(Record.count, :bar, :percentage, :eta)

  Record.all.each do |record|
    progress_bar.increment!
    #puts record.artist
    if record.artist != ""
      artist = Rockstar::Artist.new(record.artist)
      top_tag = artist.top_tags.first
    else
      top_tag = []
    end
    
    if top_tag.blank?SIN=B0095DGN3Q&linkCode=xm2&tag=vynscrapercom-20
      genre = nil
    else
      genre = top_tag.name.capitalize
    end

    #puts "Adding genre: " + genre.to_s
    #puts "----------"
    record.update_attributes(:genre => genre)
  end
end

