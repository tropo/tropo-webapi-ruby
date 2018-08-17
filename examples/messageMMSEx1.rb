require 'tropo-webapi-ruby'

require 'sinatra'

post '/index.json' do

  t = Tropo::Generator.new
  
  say = {:value => "This is an announcement",
    :allowSignals => ["sig1", "sig2"],
      :media => ["http://www.gstatic.com/webp/gallery/2.jpg", "hello ruby, not happy to see you", "http://www.gstatic.com/webp/gallery/3.jpg"],
      :as => "DIGITS",
      :name => "say-in-message",
      :required => true}
  
  t.message :say => say,
    :to => "+13072238293",
    :network => "MMS"
      
  
  headers \
      "WebAPI-Lang-Ver"   => "ruby-frank20180816",
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