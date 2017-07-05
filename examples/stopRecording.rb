#require 'tropo-webapi-ruby'
require '/Users/xiangjyu/git/tropo-webapi-ruby/lib/tropo-webapi-ruby/tropo-webapi-ruby.rb'
require 'sinatra'

post '/index.json' do

  t = Tropo::Generator.new

  t.start_recording :name => 'myrecording', :url => 'http://example.com/getrecord.php'
  t.sa505y [:value => "I am now recording!"]
  t.stop_recording

  headers \
  "WebAPI-Lang-Ver"   => "ruby-frank20170628",
  "rubyversion"   => "ruby 2.4.0p0 (2016-12-24 revision 57164) [x86_64-darwin16]"

  "This is t.response, where is t.response"
  t.response # def response  line 464

end