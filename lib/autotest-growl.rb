$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require File.join(File.dirname(__FILE__), 'autotest', 'growl')

module AutotestGrowl

  VERSION  = '0.1.4'

end
