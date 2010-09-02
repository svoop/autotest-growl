require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "autotest-growl"
    gem.summary = %q{Growl notification support for autotest.}
    gem.description = %q{This gem aims to improve support for Growl notifications by autotest.}
    gem.email = "ruby@bitcetera.com"
    gem.homepage = "http://www.bitcetera.com/products/autotest-growl"
    gem.authors = ["Sven Schwyn"]
    gem.post_install_message = "\n\e[1;32m" + File.read('PostInstall.txt') + "\e[0m\n"
    gem.files = [
      "CHANGELOG.txt",
      "growl/growlnotify",
      "growl/growlnotify.com",
      "img/ampelmaennchen/error.png",
      "img/ampelmaennchen/failed.png",
      "img/ampelmaennchen/info.png",
      "img/ampelmaennchen/passed.png",
      "img/ampelmaennchen/pending.png",
      "img/ruby/error.png",
      "img/ruby/failed.png",
      "img/ruby/info.png",
      "img/ruby/passed.png",
      "img/ruby/pending.png",
      "lib/autotest/growl.rb",
      "lib/autotest/result.rb",
    ]
    gem.add_development_dependency "rspec", "~> 1.3"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "autotest-growl #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
