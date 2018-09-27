require 'tropo-webapi-ruby'

require 'sinatra'

post '/index.json' do

  t = Tropo::Generator.new
  
  t.call :to => "+13072238293",
    :network => "MMS"
  t.say :value => "Tag, you're it!",
    :media => ["http://www.gstatic.com/webp/gallery/4.jpg", "http://www.gstatic.com/webp/gallery/5.jpg"]
  
  headers \
      "WebAPI-Lang-Ver"   => "ruby-frank201808161440",
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