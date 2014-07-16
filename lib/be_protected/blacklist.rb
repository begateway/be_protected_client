require 'uri'
module BeProtected
  class Blacklist < Base

    def add(value)
      Response::Blacklist.new request(:post, resource_path, {value: value})
    end

    def get(value)
      Response::Blacklist.new request(:get, resource_path(value))
    end

    def delete(value)
      Response::Blacklist.new request(:delete, resource_path(value))
    end

    def included?(value)
      response = get(value)

      case response.status
      when 200 then true
      when 404 then false
      else          nil
      end
    end

    private
    def resource_path(value = nil)
      "/blacklist".tap do |path|
        path << URI.escape("/#{value}") if value
      end
    end

  end
end
