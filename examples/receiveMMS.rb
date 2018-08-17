require 'tropo-webapi-ruby'
require 'sinatra'

post '/index.json' do

  v = Tropo::Generator.parse request.env["rack.input"].read
  p 'v=========='
  p v
  p 'v=========='
  textContent = v[:session][:initial_text]
  p 'initial_text  is <<<'
  p textContent  
  p 'initial_text  is >>>'
  
  
  subjectVar = v[:session][:subject]
  p 'subject  is <<<'
  p subjectVar  
  p 'subject  is >>>'
  
  mediaList = v[:session][:initial_media]
  p 'initial_media  is <<<'
  
  if not mediaList.to_a.empty?
    mediaList.each { |x| puts x[:disposition] 
      puts x[:media] 
      puts x[:status]
      # you can do your business logic with this value  
      puts x[:text] }
    p 'initial_media  is >>>'
  end 
  
end

