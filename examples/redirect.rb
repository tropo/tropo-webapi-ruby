#require 'tropo-webapi-ruby'
require '/Users/xiangjyu/git/tropo-webapi-ruby/lib/tropo-webapi-ruby/tropo-webapi-ruby.rb'
require 'sinatra'

post '/index.json' do

  t = Tropo::Generator.new

  t.redirect(:to => 'sip:9991427589@sip.tropo.com', :name => 'foooo', :required => true)
  t.response
  
end