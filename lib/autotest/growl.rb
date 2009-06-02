require 'rubygems'
require 'autotest'

##
# Autotest::Growl
#
# == FEATUERS:
# * Display autotest results as local or remote Growl notifications.
# * Clean the terminal on every test cycle while maintaining scrollback.
#
# == SYNOPSIS:
# ~/.autotest
#   require 'autotest/growl'
module Autotest::Growl

  GEM_PATH = File.expand_path(File.join(File.dirname(__FILE__), '../..'))

  @@remote_notification = false
  @@hide_label = false

  ##
  # Whether to use remote or local notificaton (default).
  def self.remote_notification=(boolean)
    @@remote_notification = boolean
  end

  ##
  # Whether to display the label (default) or not.
  def self.hide_label=(boolean)
    @@hide_label = boolean
  end

  ##
  # Display a message through Growl.
  def self.growl title, message, icon, priority=0, stick=""
    growl = File.join(GEM_PATH, 'growl', 'growlnotify')
    image = File.join(ENV['HOME'], '.autotest-growl', "#{icon}.png")
    image = File.join(GEM_PATH, 'img', "#{icon}.png") unless File.exists?(image)
    if @@remote_notification
      system "#{growl} -H localhost -n autotest --image '#{image}' -p #{priority} -m #{message.inspect} '#{title}' #{stick}"
    else
      system "#{growl} -n autotest --image '#{image}' -p #{priority} -m #{message.inspect} '#{title}' #{stick}"
    end
  end

  ##
  # Set the label and clear the terminal.
  Autotest.add_hook :run_command do
    @label = (@@hide_label) ? ('') : (File.basename(Dir.pwd).upcase + ': ')
    @run_scenarios = false
    print "\n"*2 + '-'*80 + "\n"*2
    print "\e[2J\e[f"   # clear the terminal
    false
  end

  ##
  # Parse the test results and send them to Growl.
  Autotest.add_hook :ran_command do |autotest|
    gist = autotest.results.grep(/\d+\s+(example|test)s?/).map {|s| s.gsub(/(\e.*?m|\n)/, '') }.join(" / ")
    if gist == ''
      growl @label + 'Cannot run tests.', '', 'error'
    else
      if gist =~ /[1-9]\d*\s+(failure|error)/
        growl @label + 'Some tests have failed.', gist, 'failed'
      elsif gist =~ /pending/
        growl @label + 'Some tests are pending.', gist, 'pending'
        @run_scenarios = true
      else
        growl @label + 'All tests have passed.', gist, 'passed'
        @run_scenarios = true
      end
    end
    false
  end

  # FIXME: This is a temporary workaround until Cucumber is properly integrated!
  Autotest.add_hook :waiting do |autotest|
    if @run_scenarios && !autotest.results.grep(/^\d+ scenario/).empty?
      gist = autotest.results.grep(/\d+\s+(scenario|step)s?/).map {|s| s.gsub(/(\e.*?m|\n)/, '') }.join(" / ")
      if gist == ''
        growl @label + 'Cannot run scenarios.', '', 'error'
      else
        if gist =~ /failed/
          growl @label + 'Some scenarios have failed.', gist, 'failed'
        elsif gist =~ /undefined/
          growl @label + 'Some scenarios are undefined.', gist, 'pending'
        else
          growl @label + 'All scenarios have passed.', gist, 'passed'
        end
      end
    end
    false
  end

end
