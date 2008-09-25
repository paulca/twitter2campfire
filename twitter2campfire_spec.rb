require 'rubygems'
require 'spec'
require 'twitter2campfire'

describe Twitter2Campfire do
  before(:each) do
    campfire = mock(Tinder::Campfire)
    @t = Twitter2Campfire.new('http://search.twitter.com/search.atom?q=from%3Apaulca+OR+from%3Aeoghanmccabe+OR+from%3Adestraynor+OR+from%3Adavidjrice', campfire, 'Contrast')
  end
  
  it "should get the latest tweet" do
    @t.latest_tweet.should == 'stuff'
  end
  
  it "should get the latest tweet" do
    @t.latest_tweet.should == 'stuff'
  end
end