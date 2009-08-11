# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{autotest-growl}
  s.version = "0.1.5.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sven Schwyn"]
  s.date = %q{2009-08-11}
  s.description = %q{This gem aims to improve support for Growl notification by ZenTest's autotest. It comes with a nice colored Ruby icon set and - for now - supports Cucumber by means of a workaround.}
  s.email = ["ruby@bitcetera.com"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "PostInstall.txt"]
  s.files = ["History.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc", "Rakefile", "autotest-growl.gemspec", "growl/growlnotify", "growl/growlnotify.com", "img/error.png", "img/failed.png", "img/info.png", "img/passed.png", "img/pending.png", "lib/autotest-growl.rb", "lib/autotest/growl.rb", "lib/autotest/result.rb", "script/console", "script/destroy", "script/generate", "spec/autotest-growl_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "tasks/rspec.rake"]
  s.homepage = %q{http://www.bitcetera.com/products/autotest-growl}
  s.post_install_message = %q{
[1;32mIn order to use autotest-growl, the following line has to be added to your
~/.autotest file:

require 'autotest/growl'

Make sure Growl is installed on your computer. Download it from:

http://growl.info (Mac OS X)
http://growlforwindows.com (Windows)

If Growl notifications are not always displayed, take a look at the README
for assistance.

For more information, feedback and bug submissions, please visit:

http://www.bitcetera.com/products/autotest-growl
[0m
}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{autotest-growl}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Next generation Growl notification support for ZenTest's autotest.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ZenTest>, [">= 4.1.3"])
      s.add_development_dependency(%q<hoe>, [">= 2.3.2"])
    else
      s.add_dependency(%q<ZenTest>, [">= 4.1.3"])
      s.add_dependency(%q<hoe>, [">= 2.3.2"])
    end
  else
    s.add_dependency(%q<ZenTest>, [">= 4.1.3"])
    s.add_dependency(%q<hoe>, [">= 2.3.2"])
  end
end
