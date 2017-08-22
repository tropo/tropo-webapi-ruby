require 'rubygems'
require 'sinatra'

require 'lib/tropo-webapi-ruby'

enable :sessions

set :bind => "192.168.26.1"
set :port => "4567"

post '/record.json' do
  response = Tropo::Generator.record({ :attempts=> 3,
    :asyncUpload       => true,
    :allowSignals       => ["s1", "s2"],
    :bargein       => false,
    :beep       => false,
    :choices => {:terminator => '#'},
    :say       => [{:value=>"Please leave a message"},{:value=>"Sorry, I did not hear anything. Please call back.", :event=>"timeout"}],
    :format       => 'audio/wav',
    :maxSilence       => 5.1,
    :maxTime       => 30.2,
    :method       => "POST",
    :name       => 'foo',
    :required       => false,
    :transcription        => {
                      :id=>"1234",
                      :language=>"British",
                      :url=>"mailto:you@yourmail.com"
                      },
    :url        => 'http://example.com/tropo.php',
    :password       => 'foopassword',
    :username       => 'foousername',
    :timeout       => 5.1,
    :interdigitTimeout       => 30.2,
    :voice       => 'allison',
    :promptLogSecurity       => 'none',
    :sensitivity => 3.21
  })
  p response
  response
end
