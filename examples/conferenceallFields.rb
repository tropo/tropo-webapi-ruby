require 'tropo-webapi-ruby'

require 'sinatra'

post '/index.json' do

  t = Tropo::Generator.new
  
  t.conference({
    :id => "conference-id",
    :allowSignals => ["allowSignal1","allowSignal2"],
    :interdigitTimeout => 5.1,
    :joinPrompt => {
      :value => "Please welcome frank to the party",
      :voice => "allison"
      },
    :leavePrompt => {
      :value => "alex has left the party",
      :voice => "allison"
    },
    :mute => true,
    :name => "joinLeave",
    :playTones => false,
    :required => false,
    :terminator => "#",
    :promptLogSecurity => "suppress",
  })
  
  t.response
    
end

