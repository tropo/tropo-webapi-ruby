require 'tropo-webapi-ruby'

require 'sinatra'

post '/index.json' do

  t = Tropo::Generator.new
    
    t.say("you are now being transfered")
    
    asksay = {:value=>"Sorry. Please enter you 5 digit account number again.", :event=>"nomatch"},
      {:value=>"Sorry, I did not hear anything.", :event=>"timeout"},
    {:value=>"Please enter 5 digit account number"}
    
    whisper1 = {
      :event => "ring",
      :say => {:value => "http://www.phono.com/audio/holdmusic.mp3"}
    }
    whisper2 = {
      :event => "connect",
      :ask => {
        :attempts =>3,
        :say => asksay,
        :required => true,
        :bargein => true,
        :timeout => 10,
        :name => "foo",
        :choices => {:value => "[5 DIGITS]", :mode => "dtmf"}
      }
    }
    #pppppppquts whisper1
    #pppppppquts whisper2
    
    t.transfer :to => ["14075550100","+14155551212"],
               :from => "13466549249",
               :timeout => 30.1,
               :answerOnMedia => false,
               :name => "tname",
               :required => false,
               :allowSignals => ["sig1", "sig2"],
               :machineDetection => {
                           :introduction => "This is just a test to see if you are a human or a machine. PLease hold while we determine. Almost finished. Thank you!",
                           :voice => "Victor"
                         },
               :choices => {:terminator => "#"},
               :headers => {},
               :interdigitTimeout => 5.1,
               :ringRepeat => 2,
               :playTones => false,
               :on => [whisper1, whisper2],
               :voice => "allison",
               :callbackUrl => "callbackUrlfoo",
               :promptLogSecurity => "none",
               :label => "transfer-all-fields"
               
  
    #t.on :event => 'incomplete', :next => '/hangup.json', :say => {:value =>'You have opted out from accepting this call. Goodbye'}

  
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