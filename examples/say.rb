require 'tropo-webapi-ruby'
require 'sinatra'

post '/say.json' do

  t = Tropo::Generator.new

  t.say('<speak>Hello <break time="500ms"/> World!</speak>', {:name => 'say'})

  t.response

end

post '/say1.json' do

  t = Tropo::Generator.new

  t.say({:value => '<speak>Hello <break time="1s"/> World!</speak>', :name => 'say'})

  t.response

end

post '/say_block.json' do

  t = Tropo::Generator.new do
    say('<speak>Hello <break time="500ms"/> World!</speak>', {:name => 'say'})
  end
  
  t.response

end

post '/say_block1.json' do

  t = Tropo::Generator.new do
    say({:value => '<speak>Hello <break time="1s"/> World!</speak>', :name => 'say'})
  end
  
  t.response

end
