$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'jitai'
require 'rspec'
require 'rubygems'

Spec::Runner.configure do |config|
  
end
