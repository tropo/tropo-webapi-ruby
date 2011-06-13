require 'rubygems'
require 'rake'
require 'yard'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "tropo-webapi-ruby"
    gem.summary = "Tropo Web API Ruby Gem"
    gem.description = "Ruby library for interacting with the Tropo Web API via REST & JSON"
    gem.email = "jsgoecke@voxeo.com"
    gem.homepage = "http://tropo.com"
    gem.authors = ["Jason Goecke"]
    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.files.include %w(lib/tropo-webapi-ruby.rb lib/tropo-webapi-ruby/tropo-webapi-ruby.rb lib/tropo-webapi-ruby/tropo-webapi-ruby-helpers.rb LICENSE VERSION README.markdown)
    #gem.add_dependency('json', '>= 1.2.0')
    gem.add_dependency('json_pure', '>= 1.2.0')
    gem.add_dependency('hashie', '>= 0.2.0')
    gem.required_ruby_version = '>= 1.8.6'
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "tropo #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/tropo-webapi-ruby/*.rb', 'lib/*.rb', 'README']
end
