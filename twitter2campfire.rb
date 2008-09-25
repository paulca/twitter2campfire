require 'rubygems'
require 'tinder'
require 'rio'
require 'hpricot'
require 'ostruct'
require 'time'

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
    (raw_feed/'entry').map { |e| OpenStruct.new(:from => (e/'name').inner_html, :text => (e/'title').inner_html, :link => (e/'link').first['href'], :date => Time.parse((e/'published').inner_html)) }
  end
  
  def latest_tweet
    entries.first
  end
  
  def save_latest
    archive_file << ''
    archive_file << latest_tweet.date.to_s
  end
  
  def archive_file
    rio('archived_latest.txt')
  end
  
  def archived_latest_date
    archive_file >> (string ||= "")
    Time.parse(string)
  end
  
  def posts
    entries.reject { |e| e.date.to_i <= archived_latest_date.to_i }
  end
  
  def publish_entries
    posts.reverse.each do |post|
      puts post
    end
    save_latest
  end
  
end