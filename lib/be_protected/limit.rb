module BeProtected
  class Limit < Base

    def create(params)
      Response::Limit.new request(:post, "/limits", params)
    end

    def update(uuid, params)
      Response::Limit.new request(:post, resource_path(uuid), params)
    end

    private
    def resource_path(uuid)
      "/limits/#{uuid}"
    end

  end
end
