require 'rubygems'
require 'tinder'
require 'rio'
require 'hpricot'
require 'ostruct'

class Twitter2Campfire
  attr_accessor :feed, :campfire, :room
  def initialize(feed,campfire,room)
    self.feed = feed
    self.campfire = campfire
    self.room = campfire.find_room_by_name room
  end
  
  def raw_feed
    @doc ||= Hpricot(rio(feed) > (string ||= ""))
  end
  
  def entries
    (raw_feed/'entry').map { |e| OpenStruct.new(:from => (e/'name').inner_html, :text => (e/'title').inner_html, :link => (e/'link').first['href']) }
  end
  
  def new?
    archived_latest.strip == latest_tweet.text.strip
  end
  
  def latest_tweet
    entries.first
  end
  
  def save_latest
    archive_file << latest_tweet.text
  end
  
  def archive_file
    rio('archived_latest.txt')
  end
  
  def archived_latest
    archive_file >> (string ||= "")
    string
  end
  
  def publish_entries
    return unless new?
    entries.reverse.each do |entry|
      room.speak "#{entry.from}: #{entry.text} #{entry.link}"
    end
    save_latest
  end
  
end