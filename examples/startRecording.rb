require 'tropo-webapi-ruby'
require 'sinatra'

post '/index.json' do
  t = Tropo::Generator.new
  t.start_recording :asyncUpload => false,
  :format => 'audio/wav',
  :transcriptionID => '1234',
  :transcriptionEmailFormat => 'plain',
  :transcriptionOutURI => 'yourmail@cisco.com',
  :transcriptionLanguage => 'pt-br',
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
  ]
  # [From this point, until stop_recording(), we will record what the caller *and* the IVR say]
  t.say [:value => "I am now recording!"]
  # Prompt the user to incriminate themselve on-the-record
  t.stop_recording
  t.response
end