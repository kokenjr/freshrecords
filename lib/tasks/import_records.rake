require 'amazon/ecs'
require 'rubygems'
require 'open-uri'
require 'nokogiri'
require 'progress_bar'
require 'text'
require 'rockstar'
  
USER_AGENT = "Mozilla/5.0 (X11; Linux x86_64)"

desc "Import Records"
task :import_records => :environment do

  start_time = Time.now
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
  amznsearchurl = "http://www.amazon.com/s/ref=sr_st?bbn=5174&qid=1382985462&rh=n%3A5174%2Cp_n_binding_browse-bin%3A387647011&sort=date-desc-rank"

  search_asin = []
  index1 = 1
  index2 = 0
  rcount = 1
  #progress_bar = ProgressBar.new(TOTALPAGES, :percentage, :eta)

  while index1 <= TOTALPAGES do
    #progress_bar.increment!
    puts "Progress: [ " + '%.2f' % ((index1.to_f/TOTALPAGES.to_f)*100) + "%]"

    vinylsearch = Nokogiri::HTML(open(amznsearchurl, "User-Agent" => USER_AGENT))

    vinylsearch.css(".product").each do |prod|
      #search_asin[index2] = prod.css(".title .title").attribute('href').text.split('/')[3] unless prod.css(".title .title").blank?
      search_asin[index2] = prod.attribute('name').text unless prod.attribute('name').blank?
      #puts "#{search_asin}"
      if search_asin.length == 10
        res = Amazon::Ecs.item_lookup(search_asin.join(','), {:response_group => 'Large'})
        #puts res.error
        res.items.each do |item|

          item_attributes = item.get_element('ItemAttributes')
          album_name = item_attributes.get('Title').gsub('&amp;', '&')
          artist_name = item_attributes.get('Artist').to_s.gsub('&amp;', '&')
          genre = item.get('BrowseNodes/BrowseNode/Name').gsub('&amp;', '&')
          
          genre = nil if genre == "Styles"
          
          price = item.get('OfferSummary/LowestNewPrice/FormattedPrice').to_s.gsub('$',"").to_f
          date = item_attributes.get('ReleaseDate')
          imagelink = item.get('LargeImage/URL')
          label = item_attributes.get('Label')
          asin = item.get('ASIN')
          produrl = AMZNPRODURL + asin + "?tag=vynscrapercom-20"
          stripped_album_name = album_name.gsub(/\([^)]*\)/,"").strip
          
          #Get Spotify and Discogs uris
          begin
            album_spotify_uri = MetaSpotify::Album.search("#{stripped_album_name} #{artist_name}")[:albums].try(:first).try(:uri)
            discogs_query = JSON.parse(open("http://api.discogs.com/database/search?page=1&format=vinyl&per_page=100&artist=" + CGI::escape(artist_name) + "&q=" + CGI::escape(stripped_album_name), "User-Agent" => USER_AGENT).read)
          rescue Exception => e
            puts "artist: #{artist_name}; album: #{stripped_album_name}; message #{e.message}"
            if e.message.include?("502") || e.message.include?("500")
              next
            else
              retry
            end
          end

          discogs_uri = discogs_query["results"].first.try(:[], "uri")

          rcount += 1

          record = Record.find_or_create_by(asin: asin)
          artist = Artist.find_or_create_by(name: artist_name)
          #Don't update image url if its blank
          record.update_attributes(:image_url => imagelink) unless imagelink == nil || imagelink.include?('41kG2tg40sL')
          record.update_attributes(:name => album_name, :artist_id => artist.id, :price => price, :release_date => date, :prod_url => produrl, :record_label => label, :genre => genre, spotify_uri: album_spotify_uri, discogs_uri: discogs_uri)

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
  puts "Duration = #{Time.at(Time.now - start_time).utc.strftime("%H:%M:%S")}"
end

desc "Fetch Album Art"
task :fetch_albumart => :environment do

  start_time = Time.now
  count = 0
  record_count = Record.where(image_url: nil).count

  puts "#{record_count} records have no album art"

  #progress_bar = ProgressBar.new(Record.find_all_by_image_url(nil).count, :percentage, :eta)

  Record.where(image_url: nil).each do |record|
    #progress_bar.increment!
    count += 1
    puts "Progress: [ " + '%.2f' % ((count.to_f/record_count.to_f)*100) + "%]"
    image_link = nil
    discogs_url = nil
    discogs_query = nil
      
    #make sure URL is valid, if it isn't remove the record
    begin
      resp = Net::HTTP.get_response(URI.parse(record.prod_url))
      if resp.code.match("404")
        record.destroy
        next
      end
    rescue Exception => e
      puts "Response check error: #{e.message}"
      retry
    end

    #get discogs info 
    #unless record.discogs_uri.blank?
    #  begin
    #    discogs_url = "http://api.discogs.com/#{record.discogs_uri.split("/")[2..3].join("s/")}"
    #    discogs_query = JSON.parse(open(discogs_url, "User-Agent" => USER_AGENT).read)
    #  rescue Exception => e
    #    puts "Discogs Error: #{e.message}"
    #    retry
    #  end
    #end

    #Use Spotify to find cover art
    if !record.spotify_uri.blank?
      begin
        query = JSON.parse(open("https://embed.spotify.com/oembed/?url=#{record.spotify_uri}", "User-Agent" => USER_AGENT).read) 
      rescue Exception => e
        puts "Spotify Error: #{e.message}"
        retry
      end
      image_link = query["thumbnail_url"].gsub("cover", "300")
    #elsif !record.discogs_uri.blank? && !discogs_query["images"].blank?
    #  #Use Discogs to find cover art
    #  image_link = discogs_query["images"].first["uri"]
    else
    #Use Amazon search to find cover art
      amzn_music_search_url = "http://www.amazon.com/s/ref=nb_sb_noss?url=search-alias%3Dpopular&field-keywords="
      
      begin
        record_page = Nokogiri::HTML(open(record.prod_url, "User-Agent" => USER_AGENT))
      rescue Exception => e
        puts "Amazon Error: #{e.message}"
        retry
      end
      record_page.css(".noLinkDecoration a").each do |rp|
        if rp.attribute("href").text.include?("http")
          
          #make sure url is valid, if not skip to next scraping method
          begin
            resp = Net::HTTP.get_response(URI.parse(rp.attribute("href").text))
            break if resp.code.match("404")
          rescue Exception => e
            puts "Response check error: #{e.message}"
            retry
          end
        
          begin
            rp_page = Nokogiri::HTML(open(rp.attribute("href").text, "User-Agent" => USER_AGENT))
          rescue Exception => e
            puts "Amazon Error: #{e.message}"
            retry
          end
          if !rp_page.css("#prodImage").blank? && !rp_page.css("#prodImage").attribute("src").text.include?("no-image")
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
  
      if image_link.nil? && !record.artist.blank?
        begin
          image_search = Nokogiri::HTML(open(amzn_music_search_url + CGI::escape(record.artist.name + " " + record.name), "User-Agent" => USER_AGENT))
        rescue Exception => e
          puts "Amazon Error: #{e.message}"
          retry
        end
        image_search.css(".product").each do |prod|
          prod_title = prod.css(".title .title").text.downcase.gsub(",","")
          record_title = record.name.downcase.gsub(",","")
          prod_artist = prod.css(".ptBrand").text.downcase.gsub("by ","")
          record_artist = record.artist.name.downcase

          if !prod.css(".productImage").blank? && !prod.css(".productImage").attribute("src").blank? && !prod.css(".productImage").attribute("src").text.include?('41kG2tg40sL') && (prod_artist.include?(record_artist) || record_artist.include?(prod_artist)) && (prod_title.include?(record_title) || Text::Levenshtein.distance(prod_title,record_title) <= 2 || record_title.include?(prod_title))
            image_link = prod.css(".productImage").attribute("src").text.gsub('._AA115_','').gsub('._AA160_','')
            #puts "scraped method 2"
            break
          else
            image_link = nil
          end
        end
      end
    end

    #puts "Updating art for: " + record.asin + " #" + count.to_s
    record.update_attributes(:image_url => image_link)
  end
  puts "Duration = #{Time.at(Time.now - start_time).utc.strftime("%H:%M:%S")}"
end

desc "Lastfm data"
task :fetch_lastfm => :environment do
  
  Rockstar.lastfm = {:apii_key => "7c58f1848c6ad8ff32cf07fb7e978d7b", :api_secret => "76900414f897ba5c201bba7acb71e72f"}
  progress_bar = ProgressBar.new(Record.count, :bar, :percentage, :eta)

  Record.all.each do |record|
    progress_bar.increment!
    if record.artist.name != ""
      artist = Rockstar::Artist.new(record.artist.name)
      top_tag = artist.top_tags.first
    else
      top_tag = []
    end
    
    if top_tag.blank?
      genre = nil
    else
      genre = top_tag.name.capitalize
    end

    #puts "Adding genre: " + genre.to_s
    #puts "----------"
    record.update_attributes(:genre => genre)
  end
end

