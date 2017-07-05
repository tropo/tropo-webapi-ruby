require 'tropo-webapi-ruby'

require 'sinatra'

post '/index.json' do

  t = Tropo::Generator.new
  
  asksay = {:value=>"Sorry, I did not hear anything.", :event=>"timeout"},
    {:value=>"Don't think that was a year. ", :event=>"nomatch:1"},
      {:value=>"Nope, still not a year.", :event=>"nomatch:2"},
  {:value=>"What is your birth year?"}
  choices = {:value=>"[4 DIGITS]"}
    
  t.ask :attempts=>3,
    :say=>asksay,
    :choices=>choices,
    :allowSignals=>"sig1",
    :minConfidence=>32,
    :sensitivity=>77,
    :speechCompleteTimeout=>0.6,
    :speechIncompleteTimeout=>0.56,
    :sensitivity=>77,
    :voice=>"allison",
    :promptLogSecurity=>"suppress",
    :asrLogSecurity=>"mask",
    :maskTemplate=>"XXDD-",
    :bargein=>true,
    :timeout=>60,
    :interdigitTimeout=>1,
    :name=>"year",
    :required=>true
  
  t.on :event=>"continue",
    :next=>"/your_age.json"
    
  t.on :next=>"/age_fail.json",
    :event=>"incomplete"
    
      
  
  headers \
      "WebAPI-Lang-Ver"   => "ruby-frank20170628",
      "rubyversion"   => "ruby 2.4.0p0 (2016-12-24 revision 57164) [x86_64-darwin16]"
      
  "This is t.response, where is t.response"
  t.response # def response  line 464
    
end


post '/continue.json' do
  
  v = Tropo::Generator.parse request.env["rack.input"].read
  t = Tropo::Generator.new
  #pppppppquts v
  userType = v[:result][:user_type]
  #pppppppquts userType
  t.say(:value => "You are a  #{userType}")
  
  t.response
  
end