require 'rubygems'
gem 'hoe', '>= 2.1.0'
require 'hoe'
require 'fileutils'
require './lib/autotest-growl'

Hoe.plugin :newgem
# Hoe.plugin :website
# Hoe.plugin :cucumberfeatures

$hoe = Hoe.spec 'autotest-growl' do
  self.developer              'Sven Schwyn', 'ruby@bitcetera.com'
  self.summary              = %q{Next generation Growl notification support for ZenTest's autotest.}
  self.description          = %q{This gem aims to improve support for Growl notification by ZenTest's autotest. It comes with a nice colored Ruby icon set and - for now - supports Cucumber by means of a workaround.}
  self.url                  = %q{http://www.bitcetera.com/products/autotest-growl}
# self.changes              = self.paragraphs_of("History.txt", 0..1).join("\n\n")
  self.post_install_message = "\n\e[1;32m" + File.read('PostInstall.txt') + "\e[0;30m\n"
  self.rubyforge_name       = self.name
  self.extra_deps           = [
                                ['ZenTest','>= 4.1.3'],
                              ]
end

require 'newgem/tasks'
Dir['tasks/**/*.rake'].each { |t| load t }

task :default => [:spec]
