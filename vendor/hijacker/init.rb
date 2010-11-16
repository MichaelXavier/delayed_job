# Include hook code here
$:.unshift(File.join(File.dirname(__FILE__), 'lib'))
require 'hijacker'
require 'hijacker/database'
require 'hijacker/controller_methods'

module ActionController
  class Base
    include Hijacker::ControllerMethods::Instance
  end
end
