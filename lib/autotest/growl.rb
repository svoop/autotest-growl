require 'rubygems'
require 'autotest'

$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

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

  VERSION  = '0.1.0'
  GEM_PATH = File.expand_path(File.join(File.dirname(__FILE__), '../..'))

  REMOTE_NOTIFICATION = false

  ##
  # Display a message through Growl.
  def self.growl title, message, icon, priority=0, stick=""
    growl = File.join(GEM_PATH, 'growl', 'growlnotify')
    image = File.join('~', '.autotest-growl', "#{icon}.png")
    image = File.join(GEM_PATH, 'img', "#{icon}.png") unless File.exists?(image)
    if REMOTE_NOTIFICATION
      system "#{growl} -H localhost -n autotest --image '#{image}' -p #{priority} -m #{message.inspect} '#{title}' #{stick}"
    else
      system "#{growl} -n autotest --image '#{image}' -p #{priority} -m #{message.inspect} '#{title}' #{stick}"
    end
  end

  ##
  # Set the label and clear the terminal.
  Autotest.add_hook :run_command do
    @label = File.basename(Dir.pwd).upcase
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
      growl "#{@label} cannot run tests", '', 'error'
    else
      if gist =~ /[1-9]\d*\s+(failure|error)/
        growl "#{@label} fails some tests", "#{gist}", 'failed'
      elsif gist =~ /pending/
        growl "#{@label} has pending tests", "#{gist}", 'pending'
        @run_scenarios = true
      else
        growl "#{@label} passes all tests", "#{gist}", 'passed'
        @run_scenarios = true
      end
    end
    false
  end

  # FIXME: This is a temporary workaround until Cucumber is properly integrated!
  Autotest.add_hook :waiting do |autotest|
    if @run_scenarios
      gist = autotest.results.grep(/\d+\s+(scenario|step)s?/).map {|s| s.gsub(/(\e.*?m|\n)/, '') }.join(" / ")
      if gist == ''
        growl "#{@label} cannot run scenarios", '', 'error'
      else
        if gist =~ /failed/
          growl "#{@label} fails some scenarios", "#{gist}", 'failed'
        elsif gist =~ /undefined/
          growl "#{@label} has undefined scenarios", "#{gist}", 'pending'
        else
          growl "#{@label} passes all scenarios", "#{gist}", 'passed'
        end
      end
    end
    false
  end

end
