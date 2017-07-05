#require 'tropo-webapi-ruby'
require '/Users/xiangjyu/git/tropo-webapi-ruby/lib/tropo-webapi-ruby/tropo-webapi-ruby.rb'
require 'sinatra'

post '/index.json' do

  t = Tropo::Generator.new
  
  say = {:value => "Remember, you have a meeting at 2 PM"
=begin
    :allowSignals => ["sig1", "sig2"],
      :as => "DIGITS",
      :name => "sayinmessage2",
      :required => "true",
      :voice => "allison",
      :promptLogSecurity => "none"
=end  
  }
  t.message :say => say,
    :to => "+13055551212",
    :from => "3055551000",
    :voice =>"dave",
    :timeout=>10,
    :answerOnMedia=>false,
    :headers=>{:foo=>"bar",:bling=>"baz"},
    :network => "SMS"
      
  
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