require 'rspec'
require 'base64'
require File.join(File.dirname(__FILE__), '../lib', 'be_protected')

def basic_auth_header(login, password)
  auth_phrase = "#{login}:#{password}"
  "Basic #{Base64.encode64(auth_phrase)}".chomp
end
