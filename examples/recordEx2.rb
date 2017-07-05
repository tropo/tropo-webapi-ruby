require 'rubygems'
require 'sinatra'
#require '../lib/tropo-webapi-ruby'
require '/Users/xiangjyu/git/tropo-webapi-ruby/lib/tropo-webapi-ruby/tropo-webapi-ruby.rb'

enable :sessions

post '/record.json' do
  response = Tropo::Generator.record({ :say       => [{:value=>"Please leave a message"},{:value=>"Sorry, I did not hear anything. Please call back.", :event=>"timeout"}], 
                                       :name       => 'foo', 
                                       :url        => 'http://example.com/tropo.php',
                                       :transcription        => {
                                         :id=>"1234",
                                       :url=>"mailto:you@yourmail.com"}}) do
                                         choices :terminator => '#'
                                       end
  p response
  response
end
