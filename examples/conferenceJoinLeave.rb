require 'tropo-webapi-ruby'
require 'sinatra'

post '/index.json' do

  v = Tropo::Generator.parse request.env["rack.input"].read
  t = Tropo::Generator.new
  
  callerID = v[:session][:from][:id]
    
  t.say({:value => "You are about to enter the conference room"})
  
  t.conference({
    :name => "joinLeave",
    :id => "1234",
    :joinPrompt => {
      :value => "Please welcome #{callerID} to the party"
      },
    :leavePrompt => {
      :value => "#{callerID} has left the party"
    }
  })
  
  t.response
    
end

