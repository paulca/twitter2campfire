require 'rubygems'
require 'tinder'
require 'rio'
require 'hpricot'
require 'ostruct'
require 'time'
require 'htmlentities'
require 'digest/sha1'

class Twitter2Campfire
  attr_accessor :feed, :campfire, :room, :cachefile
  def initialize(feed,campfire,room, cachefile = 'archived_latest.txt')
    self.feed = feed
    self.campfire = campfire
    self.room = campfire.find_room_by_name room
    self.cachefile = cachefile
  end
  
  def raw_feed
    @doc ||= Hpricot(rio(feed) > (string ||= ""))
  end
  
  def entries
    (raw_feed/'entry').map { |e| OpenStruct.new(:from => (e/'name').inner_html, :text => (e/'title').inner_html, :link => (e/'link[@rel=alternate]').first['href'], :checksum => Digest::SHA1.hexdigest((e/'title').inner_html), :date => Time.parse((e/'updated').inner_html)) }
  end
  
  def latest_tweet
    entries.first
  end
  
  def save_latest
    File.open(cachefile, 'w') do |file|
      file.write(new_archive_contents)
    end
  end
  
  def checksums
    entries.map { |e| e.checksum }.to_a
  end
  
  def archived_checksums
    archive_file.split("\n")[1,archive_file.length].to_a
  end
  
  def new_checksums
    [checksums + archived_checksums].flatten.uniq[0,1000]
  end
  
  def archive_file
    File.read(cachefile)
  end
  
  def new_archive_contents
    "#{Time.now}\n#{new_checksums.join("\n")}"
  end
  
  def archived_latest_date
    time = archive_file.split("\n")[0] ? archive_file.split("\n")[0] : '1 january 1970 00:00'
    Time.parse(time)
  end
  
  def posts
    entries.reject { |e| e.date.to_i <= archived_latest_date.to_i or archived_checksums.include?(e.checksum) }
  end
  
  def coder
    HTMLEntities.new
  end
  
  def publish_entries
    posts.reverse.each do |post|
      room.speak "#{coder.decode(post.from)}: #{coder.decode(post.text)} #{post.link}"
    end
    save_latest
  end
  
end
