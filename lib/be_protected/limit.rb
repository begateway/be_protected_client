module BeProtected
  class Limit < Base

    def create(params)
      Response::Limit.new request(:post, resource_path, params)
    end

    def update(uuid, params)
      Response::Limit.new request(:post, resource_path(uuid), params)
    end

    def get(uuid)
      Response::Limit.new request(:get, resource_path(uuid))
    end

    def decrease(key, params)
      Response::Limit.new request(:post, resource_path(key) + '/decrease', params)
    end

    private
    def resource_path(uuid = nil)
      "/limits".tap do |path|
        path << "/#{uuid}" if uuid
      end
    end

  end
end
