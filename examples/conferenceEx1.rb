#require 'tropo-webapi-ruby'
require '/Users/xiangjyu/git/tropo-webapi-ruby/lib/tropo-webapi-ruby/tropo-webapi-ruby.rb'
require 'sinatra'
post '/index.json' do

  t = Tropo::Generator.new
  
  t.conference({
    :playTones => true,
    :name => "foo",
    :terminator => "#",
    :id => "1234",
    :mute => false
  })
  
  t.response
    
end

