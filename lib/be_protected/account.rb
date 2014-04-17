module BeProtected
  class Account < Base

    def create(name)
      Response::Account.new request(:post, resource_path, {name: name})
    end

    def get(uuid)
      Response::Account.new request(:get, resource_path(uuid))
    end

    def update(uuid, params)
      Response::Account.new request(:post, resource_path(uuid), params)
    end

    private
    def resource_path(uuid = nil)
      "/accounts".tap do |path|
        path << "/#{uuid}" if uuid
      end
    end

  end
end
