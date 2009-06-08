begin
  require 'spec'
rescue LoadError
  require 'rubygems' unless ENV['NO_RUBYGEMS']
  gem 'rspec'
  require 'spec'
end

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'autotest/growl'

module Autotest::Growl
  @label = 'TEST'
  @run_scenarios = false

  def self.growl(title, message, icon, priority=0, stick="")
    icon
  end
end
