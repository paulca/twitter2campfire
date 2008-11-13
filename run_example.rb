CAMPFIRE_SUBDOMAIN = ''
CAMPFIRE_EMAIL = ''
CAMPFIRE_PASSWORD = '' 
CAMPFIRE_ROOM = '' # the NAME of the room, case sensitive
FEED_URL = '' # from http://search.twitter.com
DEBUG = true

require 'twitter2campfire'
campfire = Tinder::Campfire.new CAMPFIRE_SUBDOMAIN
campfire.login CAMPFIRE_EMAIL, CAMPFIRE_PASSWORD
t = Twitter2Campfire.new(FEED_URL, campfire, CAMPFIRE_ROOM)
t.publish_entries
