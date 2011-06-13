$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
%w(rubygems tropo-webapi-ruby hashie rspec rspec/autorun).each { |lib| require lib }

RSpec.configure do |config|

end
