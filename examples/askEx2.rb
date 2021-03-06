require 'tropo-webapi-ruby'

require 'sinatra'

post '/index.json' do

  t = Tropo::Generator.new
  
  onsay = {:value=>"Nice answer!", :voice=>"Victor"}
  asksay = {:value=>"Please say a digit"}
  choices = {:value=>"[1 DIGIT]"}
  
  t.on :event=>"continue",
    :next=>"continue.json",
    :say=>[onsay]
    
  t.ask :say=>[asksay],
    :voice=>"Victor",
    :sensitivity=>80,
    :name=>"foo",
    :choices=>choices
      
  
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