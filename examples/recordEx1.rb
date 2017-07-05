require 'rubygems'
require 'sinatra'
#require '../lib/tropo-webapi-ruby'


enable :sessions

post '/record.json' do
  response = Tropo::Generator.record({ :say       => [{:value=>"Please leave a message"},{:value=>"Sorry, I did not hear anything. Please call back.", :event=>"timeout"}], 
                                       :name       => 'foo', 
                                       :url        => 'http://sendme.com/tropo' }) do
                                         choices :terminator => '#'
                                       end
  p response
  response
end
