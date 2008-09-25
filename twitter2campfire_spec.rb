require 'rubygems'
require 'spec'
require 'twitter2campfire'

describe Twitter2Campfire do
  before(:each) do
    campfire = mock(Tinder::Campfire)
    campfire.stub!(:find_room_by_name)
    @t = Twitter2Campfire.new('http://search.twitter.com/search.atom?q=from%3Apaulca+OR+from%3Aeoghanmccabe+OR+from%3Adestraynor+OR+from%3Adavidjrice', campfire, 'Contrast')
  end
  
  it "should get the latest tweet" do
    @t.latest_tweet.should == 'stuff'
  end
  
  it "should get the latest entry" do
    (@t.raw_feed/'entry').first.should == 'stuff'
  end
end