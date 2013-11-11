require 'tropo-webapi-ruby'
require 'sinatra'

post '/index.json' do

  t = Tropo::Generator.new
  
  t.call :to => "+14071234321",
         :machineDetection => {
           :introduction => "This is just a test to see if you are a human or a machine. PLease hold while we determine. Almost finished. Thank you!",
           :voice => "Victor"
         }
  
  t.on :event => 'continue', :next => '/continue.json'
  t.response
    
end


post '/continue.json' do
  
  v = Tropo::Generator.parse request.env["rack.input"].read
  t = Tropo::Generator.new
  puts v
  userType = v[:result][:user_type]
  puts userType
  t.say(:value => "You are a  #{userType}")
  
  t.response
  
end