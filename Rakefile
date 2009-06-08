require 'rubygems' unless ENV['NO_RUBYGEMS']
%w[rake rake/clean fileutils newgem rubigen].each { |f| require f }
require File.dirname(__FILE__) + '/lib/autotest-growl'

$hoe = Hoe.new('autotest-growl', AutotestGrowl::VERSION) do |p|
  p.developer('Sven Schwyn', 'ruby@bitcetera.com')
  p.summary              = %q{Next generation Growl notification support for ZenTest's autotest.}
  p.description          = %q{This gem aims to improve support for Growl notification by ZenTest's autotest. It comes with a nice colored Ruby icon set and - for now - supports Cucumber by means of a workaround.}
  p.url                  = %q{http://www.bitcetera.com/products/autotest-growl}
  p.changes              = p.paragraphs_of("History.txt", 0..1).join("\n\n")
  p.post_install_message = "\n\e[1;32m" + File.read('PostInstall.txt') + "\e[0;30m\n"
  p.rubyforge_name       = p.name
  p.extra_deps         = [
    ['ZenTest','>= 4.1.0'],
  ]
  p.extra_dev_deps = [
    ['newgem', ">= #{::Newgem::VERSION}"]
  ]

  p.clean_globs |= %w[**/.DS_Store tmp *.log]
  path = (p.rubyforge_name == p.name) ? p.rubyforge_name : "\#{p.rubyforge_name}/\#{p.name}"
  p.remote_rdoc_dir = File.join(path.gsub(/^#{p.rubyforge_name}\/?/,''), 'rdoc')
  p.rsync_args = '-av --delete --ignore-errors'
end

require 'newgem/tasks'
Dir['tasks/**/*.rake'].each { |t| load t }

task :default => [:spec]