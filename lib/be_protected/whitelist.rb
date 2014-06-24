require 'uri'
module BeProtected
  class Whitelist < Base

    def add(value)
      Response::Whitelist.new request(:post, resource_path, {value: value})
    end

    def get(value)
      Response::Whitelist.new request(:get, resource_path(value))
    end

    def delete(value)
      Response::Whitelist.new request(:delete, resource_path(value))
    end

    private
    def resource_path(value = nil)
      "/whitelist".tap do |path|
        path << URI.escape("/#{value}") if value
      end
    end

  end
end
