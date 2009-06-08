require File.dirname(__FILE__) + '/spec_helper.rb'

describe "handling results" do
  before do
    @at = Autotest.new
  end

  describe "for RSpec" do
    it "should show a passing growl" do
      Autotest::Growl.should_receive(:growl).and_return('passed')
      @at.results = ["10 examples, 0 failures"]
      @at.hook(:ran_command)
    end

    it "should show a failing growl" do
      Autotest::Growl.should_receive(:growl).and_return('passed')
      @at.results = ["10 examples, 1 failures"]
      @at.hook(:ran_command)
    end

    it "should show a pending growl" do
      Autotest::Growl.should_receive(:growl).and_return('passed')
      @at.results = ["10 examples, 0 failures, 1 pending"]
      @at.hook(:ran_command)
    end
  end

  describe "for Cucumber" do
    # not sure what cucumber output looks like
    # it "should show a passing growl" do
    #   @at.results = ["10 examples, 0 failures"]
    #   @at.hook(:ran_command)
    # end
    #
    # it "should show a failing growl" do
    #   @at.results = ["10 examples, 1 failures"]
    #   @at.hook(:ran_command)
    # end
    #
    # it "should show a pending growl" do
    #   @at.results = ["10 examples, 0 failures, 1 pending"]
    #   @at.hook(:ran_command)
    # end
  end

  describe "for Test::Unit" do
    it "should show a passing growl" do
      Autotest::Growl.should_receive(:growl).and_return('passed')
      @at.results = ["1 tests, 1 assertions, 0 failures, 0 errors"]
      @at.hook(:ran_command)
    end

    it "should show a failing growl" do
      Autotest::Growl.should_receive(:growl).twice.and_return('passed')
      @at.results = ["1 tests, 1 assertions, 1 failures, 0 errors"]
      @at.hook(:ran_command)
      @at.results = ["1 tests, 1 assertions, 0 failures, 1 errors"]
      @at.hook(:ran_command)
    end
  end
end
