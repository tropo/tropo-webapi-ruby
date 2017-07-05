require 'tropo-webapi-ruby'

require 'sinatra'

post '/index.json' do

  t = Tropo::Generator.new
  
  t.say :value => "<?xml version='1.0'?><speak><say-as interpret-as=\"vxml:currency\">USD51.33</say-as></speak>"
  t.say :value => "<?xml version='1.0'?><speak><say-as interpret-as=\"vxml:digits\">20314253</say-as></speak>"
  t.say :value => "<?xml version='1.0'?><speak><say-as interpret-as=\"vxml:number\">2031.435</say-as></speak>"
  t.say :value => "<?xml version='1.0'?><speak><say-as interpret-as=\"vxml:phone\">4075551212</say-as></speak>"
  t.say :value => "<?xml version='1.0'?><speak><say-as interpret-as=\"vxml:date\">20090226</say-as></speak>"
  t.say :value => "<?xml version='1.0'?><speak><say-as interpret-as=\"vxml:time\">0515a</say-as></speak>"
      
  
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