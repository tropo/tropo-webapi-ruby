require 'tropo-webapi-ruby'
require 'sinatra'

post '/on.json' do

  t = Tropo::Generator.new

  t.on :event => 'continue', :next => '/continue.json'

  t.on :event => 'error', :next => '/error.json'

  t.say :value => 'Welcome to Tropo!', :name => 'say'

  t.on :event => 'hangup', :next => '/hangup.json'

  t.on :event => 'incomplete', :next => '/incomplete.json'

  t.response

end

post '/on1.json' do

  t = Tropo::Generator.new

  t.on :event => 'continue', :next => '/continue.json' do
    say :value => 'continue'
  end

  t.on :event => 'error', :next => '/error.json' do
    say :value => 'error'
  end

  t.say :value => 'Welcome to Tropo!', :name => 'say'

  t.on :event => 'hangup', :next => '/hangup.json' do
    say :value => 'hangup'
  end

  t.on :event => 'incomplete', :next => '/incomplete.json' do
    say :value => 'incomplete'
  end

  t.response

end

post '/continue.json' do

  requestBody = Tropo::Generator.parse request.env["rack.input"].read
  puts requestBody

end