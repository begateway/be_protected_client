module BeProtected
  class Rule < Base

    def create(params)
      Response::Rule.new request(:post, resource_path, params)
    end

    def get(uuid = nil)
      response = request(:get, resource_path(uuid))
      if uuid
        Response::Rule.new response
      else
        Response::Rules.new response
      end
    end

    def update(uuid, params)
      Response::Rule.new request(:post, resource_path(uuid), params)
    end

    def delete(uuid)
      Response::Rule.new request(:delete, resource_path(uuid))
    end

    def add_data(params)
      Response::Rule.new request(:post, resource_path + '/data', params)
    end

    private
    def resource_path(uuid = nil)
      "/rules".tap do |path|
        path << "/#{uuid}" if uuid
      end
    end

  end
end
