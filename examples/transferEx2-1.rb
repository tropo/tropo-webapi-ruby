require 'tropo-webapi-ruby'

require 'sinatra'

post '/index.json' do

  t = Tropo::Generator.new
    
    
    whisper = {
      :event => "ring",
      :say => {:value => "http://www.phono.com/audio/holdmusic.mp3"}
    }
    #pppppppquts whisper
    
    t.transfer :to => "8005551212",
               :ringRepeat => 2,
               :on => whisper
  
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