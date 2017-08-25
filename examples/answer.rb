require 'lib/tropo-webapi-ruby'

require 'sinatra'

set :bind => "192.168.26.1"
set :port => "12457"
 

post '/index.json' do

  t = Tropo::Generator.new
  
  t.answer :headers => {:keey1 => "gffdddddddddddddd",
  :keey2 => "value 2 here"}
      
  t.say :value => "i am answer method say content",
      :name => "justaname"
  
  headers \
      "WebAPI-Lang-Ver"   => "ruby-frank20170824",
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