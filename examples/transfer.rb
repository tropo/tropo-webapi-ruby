require 'tropo-webapi-ruby'
require 'sinatra'

post '/transfer.json' do

  t = Tropo::Generator.new

  t.transfer :to => 'sip:mac@192.168.26.1:5678',
  :name => 'transfer',
  :ringRepeat => 2,
  :on => {
    :event => 'ring',
    :say => {:value => 'http://www.phono.com/audio/holdmusic.mp3'
    }}
end

post '/transfer1.json' do

  t = Tropo::Generator.new

  t.transfer :to => 'sip:mac@192.168.26.1:5678',
  :name => 'transfer',
  :ringRepeat => 2 do
    on :event => 'ring' do
      say :value => 'http://www.phono.com/audio/holdmusic.mp3'
    end
    choices :terminator => '#'
  end
end

post '/transfer2.json' do

  t = Tropo::Generator.new

  t.transfer :to => 'sip:mac@192.168.26.1:5678',
  :name => 'transfer',
  :ringRepeat => 2,
  :on => [
    {
      :event => 'ring',
      :say => {:value => 'http://www.phono.com/audio/holdmusic.mp3'}
    },
    {
      :event => 'connect',
      :ask => {
        :attempts => 3,
        :say => [
          {:value => 'Sorry. Please enter you 5 digit account number again.', :event => 'nomatch'},
          {:value => 'Sorry, I did not hear anything.', :event => 'timeout'},
          {:value => 'Please enter 5 digit account number.'}
        ],
        :required => true,
        :bargein => true,
        :timeout => 15,
        :name => 'foo',
        :choices => {:value => '[5 DIGITS]', :mode => 'dtmf'}
      }
    }
  ]
end

post '/transfer3.json' do

  t = Tropo::Generator.new

  t.transfer :to => 'sip:mac@192.168.26.1:5678',
  :name => 'transfer',
  :ringRepeat => 2 do
    on :event => 'ring' do
      say :value => 'http://www.phono.com/audio/holdmusic.mp3'
    end
    on :event => 'connect' do
      ask :attempts => 3,
        :required => true,
        :bargein => true,
        :timeout => 15,
        :name => 'foo' do
          say :value => 'Sorry. Please enter you 5 digit account number again.', :event => 'nomatch'
          say :value => 'Sorry, I did not hear anything.', :event => 'timeout'
          say :value => 'Please enter 5 digit account number.'
          choices :value => '[5 DIGITS]', :mode => 'dtmf'
      end
    end
  end
end