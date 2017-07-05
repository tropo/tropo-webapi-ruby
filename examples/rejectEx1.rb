require 'tropo-webapi-ruby'

require 'sinatra'

post '/index.json' do

  t = Tropo::Generator.new

  t.reject
  t.response

end