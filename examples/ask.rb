require 'tropo-webapi-ruby'
require 'sinatra'

post '/ask.json' do

  t = Tropo::Generator.new

  t.ask :name => 'five',
  :say => {:value => 'Please say your account number.'},
  :choices => {:value => '[5 DIGITS]'}

  t.ask :name => 'one',
  :say => {:value => 'Please say a digit.'},
  :choices => {:value => '[1 DIGIT]'}

  t.on :event => 'continue', :next => '/continue.json'

  t.response

end

post '/index.json' do

  t = Tropo::Generator.new

  t.ask :name => 'five' do
    say :value => 'Please say your account number.'
    choices :value => '[5 DIGITS]'
  end

  t.ask :name => 'one' do
    say :value => 'Please say a digit.'
    choices :value => '[1 DIGIT]'
  end

  t.on :event => 'continue', :next => '/continue.json'

  t.response

end

post '/continue.json' do

  v = Tropo::Generator.parse request.env["rack.input"].read

  puts v

end