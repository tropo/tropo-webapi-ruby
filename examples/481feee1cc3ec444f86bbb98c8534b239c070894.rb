require 'tropo-webapi-ruby'

require 'sinatra'

set :bind => "192.168.26.1"
set :port => "12457"
 
post '/index.json' do
   
   t = Tropo::Generator.new
  t.record({ :name => 'recording',
             :timeout => 10,
             :maxSilence => 7,
             :maxTime => 60,
             :format => "audio/mp3",
             :url => 'ftp://ftp.tropo.com/filename.mp3',
             :username => "username",
             :password => "password", 
             :transcription => { :url => "mailto:you@email.com",
               :id => "1234"},
             :choices => { :terminator => "#"}
             }) do
                  say :value => 'Please say your name and hit pound'
              end
   t.on :event => 'continue', :next => '/continue.json'  do
              say :value => 'Please say your name and hit poun4444201707241201'
            end
   t.on :event => 'error', :next => '/error.json'  do
              say :value => 'Please say your name and hit poun52017072412015d'
            end
   t.on :event => 'error', :next => '/error2.json'  do
              say :value => 'Please say your name and hit poun62017072412016d'
            end
            
   t.say(:value => "You said 1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111")
   t.on :event => 'error', :next => '/error3.json'  do
              say :value => 'Please say your name and hit poun2017072412017d'
            end
   t.on :event => 'error', :next => '/error4.json'  do
              say :value => 'Please say your name and hit poun5201707241201'
            end

    t.response
  end 
   
post '/continue.json' do
   
   t = Tropo::Generator.new
   t.on :event => 'continue', :next => '/continue2.json'          

  t.record({ :name => 'recording',
             :timeout => 10,
             :maxSilence => 7,
             :maxTime => 60,
             :format => "audio/mp3",
             :url => 'ftp://ftp.tropo.com/filename2.mp3',
             :username => "username",
             :password => "password", 
             :transcription => { :url => "mailto:you@email.com",
               :id => "1234"},
             :choices => { :terminator => "#"}
             }) do
                  say :value => 'Please say the reason for your call and hit pound'
              end
    t.response
  end 

post '/continue2.json' do
  
  t = Tropo::Generator.new
   
  t.on :event => 'continue', :next => '/continue3.json'
   
  t.ask :name => 'number', 
        :timeout => 60, 
        :say => {:value => "What is your phone number?"},
        :choices => {:value => "[10 DIGITS]"}
   
   
  t.response
   
end
 
post '/continue3.json' do
   
  v = Tropo::Generator.parse request.env["rack.input"].read
   
  t = Tropo::Generator.new
   
  answer = v[:result][:actions][:number][:value]
   
  t.say(:value => "You said " + answer)
   
  t.response
   
end