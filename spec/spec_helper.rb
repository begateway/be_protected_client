require 'rspec'
require File.join(File.dirname(__FILE__), '../lib', 'be_protected')

def basic_auth_header(login, password)
  require 'base64'
  auth_phrase = "#{login}:#{password}"
  "Basic #{Base64.encode64(auth_phrase)}".chomp
end
