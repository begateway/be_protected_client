require 'rspec'
require 'rspec/its'
require 'webmock/rspec'
WebMock.disable!

require File.join(File.dirname(__FILE__), '../lib', 'be_protected')
