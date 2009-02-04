require 'rubygems'
require 'tinder'
require 'rio'
require 'hpricot'
require 'ostruct'
require 'time'
require 'htmlentities'
require 'digest/sha1'

class Twitter2Campfire
  attr_accessor :feed, :campfire, :room, :cachefile, :options
  
  def initialize(feed,campfire,room, cachefile = 'archived_latest.txt', options = {})
    self.feed = feed
    self.campfire = campfire
    self.room = campfire.find_room_by_name room
    self.cachefile = cachefile
    self.options = options
  end
  
  def raw_feed
    @doc ||= Hpricot(rio(feed) > (string ||= ""))
  end
  
  def entries
    (raw_feed/'entry').map do |e|
      OpenStruct.new(
        :from => (e/'name').inner_html,
        :text => (e/'title').inner_html,
        :link => (e/'link[@rel=alternate]').first['href'],
        :checksum => Digest::SHA1.hexdigest((e/'title').inner_html),
        :date => Time.parse((e/'updated').inner_html),
        :twicture => "http://twictur.es/i/#{(e/'id').inner_html.split(':').last}.gif"
        )
    end
  end
  
  def latest_tweet
    entries.first
  end
  
  def save_latest
    f = File.exist?(cachefile)? File.open(cachefile, 'a') : File.new(cachefile, 'w')
    f.write("\n#{new_archive_contents}")
  end
  
  def checksums
    entries.map { |e| e.checksum }.to_a
  end
  
  def archived_checksums
    archive_file.split("\n")
  end
  
  def new_checksums
    checksums.flatten.uniq[0,1000]
  end
  
  def archive_file
    begin
      return File.read(cachefile)
    #rescue
    #  ''
    end
  end
  
  def new_archive_contents
    "#{new_checksums.join("\n")}"
  end
  
  def posts
    entries.reject { |e| archived_checksums.include?(e.checksum) }
  end
  
  def coder
    HTMLEntities.new
  end
  
  def publish_entries
    posts.reverse.each do |post|
      if options[:twicture]
        room.speak post.twicture
      else
        room.speak "#{coder.decode(post.from)}: #{coder.decode(post.text)} #{post.link}"
      end
    end
    save_latest
  end
  
end
