require 'tropo-webapi-ruby'

require 'sinatra'

post '/index.json' do

  t = Tropo::Generator.new
    
    
    whisper = {
      :event => "ring",
      :next => "http://example.com/ringback.mp3"
    }
    #pppppppquts whisper
    
    t.transfer :to => "+14155551212",
               :timeout => 5,
               :on => whisper
               
               
    whisper1 = {
      :event => "incomplete",
      :say => [{:value => "no answer"}]
    }
    whisper2 = {
      :event => "continue",
      :next => "/transfer-over"
    }
    #pppppppquts whisper1
    #pppppppquts whisper2
    
    #t.on => [whisper1,whisper2]
    
    
      t.on :event => "incomplete",
           :say => [{:value => "no answer"}]
      
      t.on :event => "continue",
        :next => "/transfer-over"
    
=begin
    t.on :event => "incomplete",
         :say => {:value => "no answer"}
    
    t.on :event => "continue",
      :next => "/transfer-over"
=end

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