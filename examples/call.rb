require 'tropo-webapi-ruby'
require 'sinatra'

post '/call.json' do

  t = Tropo::Generator.new

  t.call :to => 'sip:mac@192.168.26.1:5678', :name => 'call'
  t.say :value => "Tag, you're it!", :name => 'say'

  t.response

end