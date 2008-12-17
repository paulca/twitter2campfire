require 'rubygems'
require 'spec'
require 'twitter2campfire'

describe Twitter2Campfire, "with a cachefile" do
  before(:each) do
    campfire = mock(Tinder::Campfire)
    campfire.stub!(:find_room_by_name)
    @t = Twitter2Campfire.new('http://search.twitter.com/search.atom?q=from%3Apaulca+OR+from%3Aeoghanmccabe+OR+from%3Adestraynor+OR+from%3Adavidjrice', campfire, 'Contrast', 'fixtures/test_cachefile.txt')
    @t.stub!(:raw_feed).and_return(Hpricot(File.open('fixtures/sample.xml')))
  end
  
  it "should get the latest tweet" do
    @t.latest_tweet.text.should match(/svenfuchs/)
  end
  
  it "should get the latest entry" do
    ((@t.raw_feed/'entry').first/'title').first.inner_html.should match(/svenfuchs/)
  end
  
  
  it "should get the archived checksums" do
    @t.archived_checksums.should == ['be7bb22cc88ff98bfd4ffe3c45ad89a7f3f4e86a', '81d405cd1e3b4bb6c959419e57c2a5c7abe688cb']
  end
  
  it "should have all the entries" do
    @t.entries.size.should == 15
  end
  
  it "have the first checksum" do
    @t.checksums.first.should == 'be7bb22cc88ff98bfd4ffe3c45ad89a7f3f4e86a'
  end
  
  it "have the last checksum" do
    @t.checksums.last.should == '81d405cd1e3b4bb6c959419e57c2a5c7abe688cb'
  end
  
  it "should have 15 checksums" do
    @t.checksums.size.should == 15
  end
  
  it "should only have 13 posts" do
    @t.posts.size.should == 13
  end
  
  it "should have a bunch of new checksums" do
    @t.new_checksums.size.should == 15
  end
  
  it "should save the new archive contents" do
    @t.new_archive_contents.split("\n").size.should == 15
  end
end

describe Twitter2Campfire, "with a blank cachefile" do
  before(:each) do
    campfire = mock(Tinder::Campfire)
    campfire.stub!(:find_room_by_name)
    @t = Twitter2Campfire.new('http://search.twitter.com/search.atom?q=from%3Apaulca+OR+from%3Aeoghanmccabe+OR+from%3Adestraynor+OR+from%3Adavidjrice', campfire, 'Contrast', 'fixtures/test_blank_cachefile.txt')
    @t.stub!(:raw_feed).and_return(Hpricot(File.open('fixtures/sample.xml')))
  end
  
  it "should get the latest tweet" do
    @t.latest_tweet.text.should match(/svenfuchs/)
  end
  
  it "should get the latest entry" do
    ((@t.raw_feed/'entry').first/'title').first.inner_html.should match(/svenfuchs/)
  end
  
  it "should get the archived checksums" do
    @t.archived_checksums.should == []
  end
  
  it "should have all the entries" do
    @t.entries.size.should == 15
  end
  
  it "have the first checksum" do
    @t.checksums.first.should == 'be7bb22cc88ff98bfd4ffe3c45ad89a7f3f4e86a'
  end
  
  it "have the last checksum" do
    @t.checksums.last.should == '81d405cd1e3b4bb6c959419e57c2a5c7abe688cb'
  end
  
  it "should have 15 checksums" do
    @t.checksums.size.should == 15
  end
  
  it "should only have 13 posts" do
    @t.posts.size.should == 15
  end
  
  it "should have a bunch of new checksums" do
    @t.new_checksums.size.should == 15
  end
end
