require 'tropo-webapi-ruby'
require 'sinatra'

post '/on.json' do

  t = Tropo::Generator.new

  t.say :value => 'Welcome to Tropo!', :name => 'say'

  t.on :event => 'continue', :next => '/continue.json'

  t.response

end

post '/on1.json' do

  t = Tropo::Generator.new

  t.say :value => 'Welcome to Tropo!', :name => 'say'

  t.on :event => 'continue', :next => '/continue.json' do
    say :value => 'continue'
  end

  t.response

end

post '/continue.json' do

  requestBody = Tropo::Generator.parse request.env["rack.input"].read
  puts requestBody

end