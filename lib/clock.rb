require File.expand_path('../../config/boot',        __FILE__)
require File.expand_path('../../config/environment', __FILE__)
require 'clockwork'
require 'rest-client'

include Clockwork

every(5.seconds, 'Calling robots') { 
  url = Rails.env.production? ? "horus01.arcturus.io:3000" : "10.1.10.111:3000"
  puts "url=#{url}"
  puts RestClient.get "http://arcturus:huxnGrbNfQFR@#{url}/api/online"
}
