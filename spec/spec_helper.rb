# Ugly setup stuff we have to do to test outside of a rails project
require 'setup/active_record'
ENV['RAILS_ENV'] = 'test'
require File.join(File.dirname(__FILE__), "../vendor/hijacker/init")

$:.unshift(File.dirname(__FILE__) + '/../lib')

require 'rubygems'
require 'spec'
require 'logger'

gem 'rails', '~>2.3.5'

require 'delayed_job'
require 'sample_jobs'

Delayed::Worker.logger = Logger.new('/tmp/dj.log')
RAILS_ENV = 'test'

# determine the available backends
BACKENDS = []
Dir.glob("#{File.dirname(__FILE__)}/setup/*.rb") do |backend|
  begin
    backend = File.basename(backend, '.rb')
    require "backend/#{backend}_job_spec"
    BACKENDS << backend.to_sym
  rescue LoadError
    puts "Unable to load #{backend} backend! #{$!}"
  end
end

ActiveRecord::Base.logger = Delayed::Worker.logger

# Purely useful for test cases...
class Story < ActiveRecord::Base
  def tell; text; end       
  def whatever(n, _); tell*n; end
  
  handle_asynchronously :whatever
end

Delayed::Worker.backend = BACKENDS.first

Spec::Runner.configure do |config|
  config.before(:each) do
    Hijacker.stub(:current_client).and_return('test')
    Hijacker.stub(:connect)
  end
end
