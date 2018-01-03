require 'tropo-webapi-ruby'
require 'sinatra'

post '/record.json' do

  t = Tropo::Generator.new

  t.record :attempts => 1,
  :asyncUpload => false,
  :bargein => true,
  :beep => true,
  :choices => {:terminator => '#'},
  :format => "audio/wav",
  :maxSilence => 5,
  :maxTime => 30,
  :required => true,
  :name => 'record',
  :say => [{:value => 'Please leave a message'},
    {:value => 'Sorry, I did not hear anything. Please call back.',
    :event => 'timeout'}
  ],
  :timeout => 30,
  :transcription => {
    :id=>"1234",
    :language=>"en-uk",
    :url=>"mailto:you@yourmail.com",
    :emailFormat => 'omit',
  },
  :url => [{:url => 'http://192.168.26.204/tropo-webapi-php/upload1_file.php.',
    :username => 'root',
    :password => '111111',
    :methed => 'POST'
    },
    {:url => 'http://192.168.26.203/tropo-webapi-php/upload1_file.php.',
    :username => 'root',
    :password => '111111',
    :methed => 'POST'
    }
  ],
  :voice => 'allison',
  :allowSignals => ['quit', 'exit'],
  :interdigitTimeout => 5,
  :promptLogSecurity => 'suppress',
  :sensitivityÏ => 0.5

  t.response

end

post '/record1.json' do

  t = Tropo::Generator.new

  t.record :name => 'year',
  :url => {:url => 'http://192.168.26.204/tropo-webapi-php/upload1_file.php.',
    :username => 'root',
    :password => '111111',
    :methed => 'POST'} do
    say [{:value => 'Sorry, I did not hear anything. Please call back.', :event => 'timeout'},
      {:value => 'Please leave a message'}]
    choices :terminator => '#'
  end

  t.response

end