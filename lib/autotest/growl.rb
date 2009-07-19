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

  @label = ''
  @modified_files = []

  @@remote_notification = false
  @@clear_terminal = true
  @@hide_label = false
  @@show_modified_files = false

  ##
  # Whether to use remote or local notificaton (default).
  def self.remote_notification=(boolean)
    @@remote_notification = boolean
  end

  ##
  # Whether to clear the terminal before running tests (default) or not.
  def self.clear_terminal=(boolean)
    @@clear_terminal = boolean
  end

  ##
  # Whether to display the label (default) or not.
  def self.hide_label=(boolean)
    @@hide_label = boolean
  end

  ##
  # Whether to display the modified files or not (default).
  def self.show_modified_files=(boolean)
    @@show_modified_files = boolean
  end

  ##
  # Display a message through Growl.
  def self.growl(title, message, icon, priority=0, stick="")
    growl = File.join(GEM_PATH, 'growl', 'growlnotify')
    image = File.join(ENV['HOME'], '.autotest-growl', "#{icon}.png")
    image = File.join(GEM_PATH, 'img', "#{icon}.png") unless File.exists?(image)
    if @@remote_notification
      system "#{growl} -H localhost -n autotest --image '#{image}' -p #{priority} -m '#{message}' '#{title}' #{stick}"
    else
      system "#{growl} -n autotest --image '#{image}' -p #{priority} -m '#{message}' '#{title}' #{stick}"
    end
  end

  ##
  # Analyze test results and return the numbers in a hash or nil.
  def self.analyze(results)
    results.map! {|s| s.gsub(/(\e.*?m|\n)/, '') }   # remove escape sequences
    results.reject! {|line| !line.match(/\d+\s+(example|test|scenario|step)s?/) }   # isolate result numbers
    unless results.empty?
      results = results.join(' ').gsub(/\W+/, ' ').split(' ')   # clean brackets, commas and such
      results = results.map do |r| 
        r.sub(/s$/, '')   # singularize
        r.sub(/failure/, 'failed')   # homogenize
      end
      results = Hash[*results.reverse]   # create numbers hash
      results.reject {|k, v| v.to_i == 0 }   # remove zero numbers
    end
  end

  def pretty(*args)
    'not yet done'
  end

  ##
  # Display the modified files.
  Autotest.add_hook :updated do |autotest, modified|
    if @@show_modified_files
      if modified != @last_modified
        growl @label + 'Modifications detected.', modified.collect {|m| m[0]}.join(', '), 'info', 0
        @last_modified = modified
      end
    end
    false
  end

  ##
  # Set the label and clear the terminal.
  Autotest.add_hook :run_command do
    @label = File.basename(Dir.pwd).upcase + ': ' if !@@hide_label
    @run_scenarios = false   # WORKAROUND
    print "\n"*2 + '-'*80 + "\n"*2
    print "\e[2J\e[f" if @@clear_terminal
    false
  end

  ##
  # Parse the RSpec and Test::Unit results and send them to Growl.
  Autotest.add_hook :ran_command do |autotest|
    results = analyze(autotest.results)
    if results
      case autotest.testlib
      when 'rspec'
        if results['failed']
          growl @label + 'Some RSpec examples have failed.', pretty('example', 'failed', 'pending'), 'failed', 2
        elsif numbers['pending']
          growl @label + 'Some RSpec examples are pending.', pretty('example', 'pending'), 'pending', -1
        else
          growl @label + 'All RSpec examples have passed.', pretty('example'), 'passed', -2
          @run_scenarios = true   # WORKAROUND
        end
      when 'test/unit'
        if results['error']
          growl @label + 'Cannot run some unit tests.', pretty(['assertion', 'in', 'test'], 'error'), 'error', 2
        elsif results['failed']
          growl @label + 'Some unit tests have failed.', pretty(['assertion', 'in', 'test'], 'failed'), 'failed', 2
        else
          growl @label + 'All unit tests have passed.', pretty(['assertion', 'in', 'test']), 'passed', -2
          @run_scenarios = true   # WORKAROUND
        end
      when 'cucumber'
        growl 'HOOK FIRED', 'cool', 'passed'
        # WORKARDOUND: Hooked to :waiting until properly integrated in ZenTest.
      end
    else
      growl @label + 'Cannot run tests.', '', 'error', 2
    end
    false
  end

=begin
  ##
  # WORKAROUND: Parse the Cucumber results and send them to Growl.
  Autotest.add_hook :waiting do |autotest|
    if @run_scenarios && !autotest.results.grep(/^\d+ scenario/).empty?
      gist = autotest.results.map {|s| s.gsub(/(\e.*?m|\n)/, '') }.grep(/\d+\s+(scenario|step)s?/).join(", ")
      if gist == ''
        growl @label + 'Cannot run Cucumber scenarios.', '', 'error', 2
      else
        if gist =~ /failed/
          growl @label + 'Some Cucumber scenarios have failed.', gist, 'failed', 2
        elsif gist =~ /undefined/
          growl @label + 'Some Cucumber scenarios are undefined.', gist, 'pending', -1
        else
          growl @label + 'All Cucumber scenarios have passed.', gist, 'passed', -2
        end
      end
    end
    false
  end
=end

end
