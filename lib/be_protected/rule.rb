module BeProtected
  class Rule < Base

    def create(action, condition, name_alias)
      Response::Rule.new request(:post, resource_path,
        {
          action: action,
          condition: condition,
          alias: name_alias
        }
      )
    end

    def get(uuid)
      Response::Rule.new request(:get, resource_path(uuid))
    end

    def update(uuid, params)
      Response::Rule.new request(:post, resource_path(uuid), params)
    end

    private
    def resource_path(uuid = nil)
      "/rules".tap do |path|
        path << "/#{uuid}" if uuid
      end
    end

  end
end
