require 'tropo-webapi-ruby'

require 'sinatra'

post '/index.json' do

  t = Tropo::Generator.new
  
  onsay = {:value=>"Nice answer!", :voice=>"Victor"}
    
  asksay = {:value=>"Please say 5 digits"}
  choices = {:value=>"[5 DIGITS]"}
  
  asksay2 = {:value=>"What color do you like?"}
  choices2 = {:value=>"red(red,1), blue(blue,2)"}
  
  t.on :event=>"continue",
    :next=>"continue.json"
    
  t.ask :say=>[asksay],
    :sensitivity=>80,
    :name=>"fivenum",
    :choices=>choices
      
  t.ask :say=>[asksay2],
    :sensitivity=>80,
    :name=>"yourcolor",
    :choices=>choices2
      
  
  headers \
      "WebAPI-Lang-Ver"   => "ruby-frank20170628",
      "rubyversion"   => "ruby 2.4.0p0 (2016-12-24 revision 57164) [x86_64-darwin16]"
      
  "This is t.response, where is t.response"
  t.response # def response  line 464
    
end


post '/continue.json' do
  
  v = Tropo::Generator.parse request.env["rack.input"].read
  t = Tropo::Generator.new
  #pppppppquts 'v is <<<'
  #pppppppquts v
  #pppppppquts 'v is >>>'
  actions = v[:result][:actions]
  p 'actions  is <<<'
  p actions  
  p 'actions  is >>>'
  
  yourcolorname = Tropo::Generator.getValueByActionNameKey(actions, 'yourcolor', 'name')
  yourcolorattempts = Tropo::Generator.getValueByActionNameKey(actions, 'yourcolor', 'attempts')
  yourcolordisposition = Tropo::Generator.getValueByActionNameKey(actions, 'yourcolor', 'disposition')
  yourcolorconfidence = Tropo::Generator.getValueByActionNameKey(actions, 'yourcolor', 'confidence')
  yourcolorinterpretation = Tropo::Generator.getValueByActionNameKey(actions, 'yourcolor', 'interpretation')
  yourcolorutterance = Tropo::Generator.getValueByActionNameKey(actions, 'yourcolor', 'utterance')
  yourcolorvalue = Tropo::Generator.getValueByActionNameKey(actions, 'yourcolor', 'value')
  yourcolorconcept = Tropo::Generator.getValueByActionNameKey(actions, 'yourcolor', 'concept')
  yourcolorxml = Tropo::Generator.getValueByActionNameKey(actions, 'yourcolor', 'xml')
  yourcoloruploadStatus = Tropo::Generator.getValueByActionNameKey(actions, 'yourcolor', 'uploadStatus')
  
  
  yournumname = Tropo::Generator.getValueByActionNameKey(actions, 'fivenum', 'name')
  yournumattempts = Tropo::Generator.getValueByActionNameKey(actions, 'fivenum', 'attempts')
  yournumdisposition = Tropo::Generator.getValueByActionNameKey(actions, 'fivenum', 'disposition')
  yournumconfidence = Tropo::Generator.getValueByActionNameKey(actions, 'fivenum', 'confidence')
  yournuminterpretation = Tropo::Generator.getValueByActionNameKey(actions, 'fivenum', 'interpretation')
  yournumutterance = Tropo::Generator.getValueByActionNameKey(actions, 'fivenum', 'utterance')
  yournumvalue = Tropo::Generator.getValueByActionNameKey(actions, 'fivenum', 'value')
  yournumconcept = Tropo::Generator.getValueByActionNameKey(actions, 'fivenum', 'concept')
  yournumxml = Tropo::Generator.getValueByActionNameKey(actions, 'fivenum', 'xml')
  yournumuploadStatus = Tropo::Generator.getValueByActionNameKey(actions, 'fivenum', 'uploadStatus')
  
  #yourcolor = v[:result][:actions][:yourcolor]
  t.say(:value => "color is   #{yourcolorname}")
  t.say(:value => "color is   #{yourcolorattempts}")
  t.say(:value => "color is   #{yourcolordisposition}")
  t.say(:value => "color is   #{yourcolorconfidence}")
  t.say(:value => "color is   #{yourcolorinterpretation}")
  t.say(:value => "color is   #{yourcolorutterance}")
  t.say(:value => "color is   #{yourcolorvalue}")
  t.say(:value => "color is   #{yourcolorconcept}")
  t.say(:value => "color is   #{yourcolorxml}")
  t.say(:value => "color is   #{yourcoloruploadStatus}")
  
  t.say(:value => "account  #{yournumname}")
  t.say(:value => "account  #{yournumattempts}")
  t.say(:value => "account  #{yournumdisposition}")
  t.say(:value => "account  #{yournumconfidence}")
  t.say(:value => "account  #{yournuminterpretation}")
  t.say(:value => "account  #{yournumutterance}")
  t.say(:value => "account  #{yournumvalue}")
  t.say(:value => "account  #{yournumconcept}")
  t.say(:value => "account  #{yournumxml}")
  t.say(:value => "account  #{yournumuploadStatus}")
  
  #yournum = v[:result][:actions][:fivenum]
  #yournum = Tropo::Generator.getValueByActionNameKey(actions, 'fivenum', 'value')
  ##pppppppquts yournum
  #t.say(:value => "You  said  #{yournum}")
  
  t.response
  
end