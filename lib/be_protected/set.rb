module BeProtected
  class Set < Base

    def create(params)
      Response::Set.new request(:post, resource_path, params)
    end

    def get(uuid = nil)
      response = request(:get, resource_path(uuid))
      if uuid
        Response::Set.new response
      else
        Response::Sets.new response
      end
    end

    def update(uuid, params)
      Response::Set.new request(:post, resource_path(uuid), params)
    end

    def delete(uuid)
      Response::Set.new request(:delete, resource_path(uuid))
    end

    private
    def resource_path(uuid = nil)
      "/sets".tap do |path|
        path << "/#{uuid}" if uuid
      end
    end

  end
end
