require 'tropo-webapi-ruby'

require 'sinatra'

post '/index.json' do

  t = Tropo::Generator.new
  
  t.say([:value => "Hello, about to transfer you"])
  
  t.transfer :to => "sip:9991427589@example.com"

  
  headers \
      "Allow"   => "BREW, POST, GET, PROPFIND, WHEN",
      "Refresh" => "Refresh: 20; http://www.ietf.org/rfc/rfc2324.txt"
      
  t.response
    
end

post '/hangup.json' do
  t = Tropo::Generator.new

  t.hangup
  t.response

end