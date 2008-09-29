CAMPFIRE_SUBDOMAIN = ''
CAMPFIRE_EMAIL = ''
CAMPFIRE_PASSWORD = ''
CAMPFIRE_ROOM = ''
FEED_URL = ''

require 'twitter2campfire'
campfire = Tinder::Campfire.new CAMPFIRE_SUBDOMAIN
campfire.login CAMPFIRE_EMAIL, CAMPFIRE_PASSWORD
t = Twitter2Campfire.new(FEED_URL, campfire, CAMPFIRE_ROOM)
t.publish_entries