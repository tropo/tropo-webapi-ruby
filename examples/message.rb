require 'tropo-webapi-ruby'
require 'sinatra'

post '/message.json' do

  t = Tropo::Generator.new

  t.message :to => 'sip:mac@192.168.26.1:5678',
  :name => "foo",
  :say => {:value => 'This is an announcement'}

  t.on :event => "continue", :next => "continue.json"

  t.response

end

post '/message1.json' do

  t = Tropo::Generator.new

  t.message :to => 'sip:mac@192.168.26.1:5678',
  :name => "foo" do
    say :value => 'This is an announcement'
  end

  t.on :event => "continue", :next => "continue.json"

  t.response

end

post '/continue.json' do

  v = Tropo::Generator.parse request.env["rack.input"].read
  puts v

end