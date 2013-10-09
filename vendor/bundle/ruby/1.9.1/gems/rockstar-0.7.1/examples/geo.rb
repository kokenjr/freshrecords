require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'rockstar'))

# Please enter your API-Keys into lastfm.yml first. 
# You can find them here : http://www.lastfm.de/api/account
Rockstar.lastfm = YAML.load_file(File.join(File.dirname(__FILE__), 'lastfm.yml'))

geo = Rockstar::Geo.new

geo.events(:location => 'london').each{|e| p "#{e.title} at #{e.venue.name}"}


# Get Top Tracks by country of the last week
#<toptracks country="Spain">  
#  <track rank="1">
#    <name>Violet Hill</name>
#    <playcount>1055</playcount>
#    <mbid/>
#    <url>http://www.last.fm/music/Coldplay/_/Violet+Hill</url>
#    <streamable fulltrack="0">1</streamable>
#    <artist>
#      <name>Coldplay</name>
#      <mbid>cc197bad-dc9c-440d-a5b5-d52ba2e14234</mbid>
#      <url>http://www.last.fm/music/Coldplay</url>
#    </artist>
#    <image size="small">...</image>
#    <image size="medium">...</image>
#    <image size="large">...</image>
#  </track>
#  ...
#</toptracks>
geo.toptracks('united kingdom', 10).each{|t| p "#{t.name} by #{t.artist}"}


#Get the most popular artists on Last.fm by country
#<topartists country="Spain"  page="1" perPage="50" totalPages="10" total="500">
#
#                        <artist rank="1">
#    <name>Muse</name>
#                <listeners>1736</listeners>
#                <mbid>1695c115-bf3f-4014-9966-2b0c50179193</mbid>
#                        <url>http://www.last.fm/music/Muse</url>
#    <streamable>1</streamable>
#            <image size="small">http://userserve-ak.last.fm/serve/34/416065.jpg</image>
#        <image size="medium">http://userserve-ak.last.fm/serve/64/416065.jpg</image>
#        <image size="large">http://userserve-ak.last.fm/serve/126/416065.jpg</image>
#        <image size="extralarge">http://userserve-ak.last.fm/serve/252/416065.jpg</image>
#        <image size="mega">http://userserve-ak.last.fm/serve/500/416065/Muse.jpg</image>
#    </artist>                    <artist rank="2">
#    <name>Coldplay</name>
#                <listeners>1497</listeners>
#                <mbid>cc197bad-dc9c-440d-a5b5-d52ba2e14234</mbid>
#                        <url>http://www.last.fm/music/Coldplay</url>
#    <streamable>1</streamable>
#            <image size="small">http://userserve-ak.last.fm/serve/34/210303.jpg</image>
#        <image size="medium">http://userserve-ak.last.fm/serve/64/210303.jpg</image>
#        <image size="large">http://userserve-ak.last.fm/serve/126/210303.jpg</image>
#        <image size="extralarge">http://userserve-ak.last.fm/serve/252/210303.jpg</image>
#        <image size="mega">http://userserve-ak.last.fm/serve/500/210303/Coldplay.jpg</image>
#    </artist>                    <a
geo.topartists('united kingdom', 10).each{|a| p "artist #{a.name} with #{a.listenercount} listeners"}
