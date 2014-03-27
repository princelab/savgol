# encoding: utf-8

require 'rubygems'
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://guides.rubygems.org/specification-reference for more options
  gem.name = "savgol"
  gem.homepage = "http://github.com/princelab/savgol"
  gem.license = "MIT"
  gem.summary = %Q{performs savitsky-golay smoothing}
  gem.description = "Extending Array class with method which calculates applies Savitzky-Golay filter used for smoothing the data"
  gem.email = "jtprince@gmail.com"
  gem.authors = ["John T. Prince", "Ondra Beneš"]
  gem.add_development_dependency "jeweler", "~> 1.8", ">= 1.8.3"
  gem.files = Dir.glob('lib/**/*.rb')
end
Jeweler::RubygemsDotOrgTasks.new

# require 'rspec/core'
# require 'rspec/core/rake_task'
# RSpec::Core::RakeTask.new(:spec) do |spec|
#   spec.pattern = FileList['spec/**/*_spec.rb']
# end
# 
# task :default => :spec
# 
# require 'rdoc/task'
# Rake::RDocTask.new do |rdoc|
#   version = File.exist?('VERSION') ? File.read('VERSION') : ""
# 
#   rdoc.rdoc_dir = 'rdoc'
#   rdoc.title = "savgol #{version}"
#   rdoc.rdoc_files.include('README*')
#   rdoc.rdoc_files.include('lib/**/*.rb')
# end
