require File.dirname(__FILE__) + '/spec_helper.rb'

describe "handling results" do
  before do
    @autotest = Autotest.new
  end

  describe "for RSpec" do
    it "should show a passing Growl notification" do
      Autotest::Growl.should_receive(:growl).and_return('passed')
      @autotest.results = ["10 examples, 0 failures"]
      @autotest.hook(:ran_command)
    end

    it "should show a failing Growl notification" do
      Autotest::Growl.should_receive(:growl).and_return('passed')
      @autotest.results = ["10 examples, 1 failures"]
      @autotest.hook(:ran_command)
    end

    it "should show a pending Growl notification" do
      Autotest::Growl.should_receive(:growl).and_return('passed')
      @autotest.results = ["10 examples, 0 failures, 1 pending"]
      @autotest.hook(:ran_command)
    end
  end

  describe "for Test::Unit" do
    it "should show a passing Growl notification" do
      Autotest::Growl.should_receive(:growl).and_return('passed')
      @autotest.results = ["1 tests, 1 assertions, 0 failures, 0 errors"]
      @autotest.hook(:ran_command)
    end

    it "should show a failing Growl notification" do
      Autotest::Growl.should_receive(:growl).twice.and_return('passed')
      @autotest.results = ["1 tests, 1 assertions, 1 failures, 0 errors"]
      @autotest.hook(:ran_command)
      @autotest.results = ["1 tests, 1 assertions, 0 failures, 1 errors"]
      @autotest.hook(:ran_command)
    end
  end

  # FIXME: This is a temporary workaround until Cucumber is properly integrated!
  describe "for Cucumber" do
    it "should show a passing Growl notification"
    it "should show a failing Growl notification"
    it "should show a pending Growl notification"
  end
end
