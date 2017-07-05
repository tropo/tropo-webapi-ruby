require 'tropo-webapi-ruby'

require 'sinatra'
post '/index.json' do

  t = Tropo::Generator.new
  
  t.conference({
    :playTones => true,
    :name => "foo",
    :terminator => "#",
    :id => "1234",
    :mute => false
  })
  
  t.response
    
end

