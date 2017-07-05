require 'rubygems'
require 'sinatra'
#require '../lib/tropo-webapi-ruby'


enable :sessions

post '/record.json' do
  response = Tropo::Generator.record({ :name       => 'foo', 
                                       :url        => 'http://sendme.com/tropo', 
                                       :beep       => true,
                                       :send_tones => false,
                                       :exit_tone  => '#' }) do
                                         say     :value => 'Please say your acco35unt number'
                                         choices :value => '[506 DIGITS]'
                                       end
  p response
  response
end
