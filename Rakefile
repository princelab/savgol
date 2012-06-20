# encoding: utf-8

require 'rubygems'
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "savgol"
  gem.homepage = "http://github.com/princelab/savgol"
  gem.license = "MIT"
  gem.summary = %Q{performs savitsky-golay smoothing}
  gem.description = %Q{performs savitsky-golay smoothing}
  gem.email = "jtprince@gmail.com"
  gem.authors = ["John T. Prince"]
  gem.add_runtime_dependency 'ruby-svd', "~> 0.5.1"
  gem.add_development_dependency "rspec", "~> 2.8.0"
  gem.add_development_dependency "rdoc", "~> 3.12"
  gem.add_development_dependency "jeweler", "~> 1.8.3"
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "savgol #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
