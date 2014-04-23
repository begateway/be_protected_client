module BeProtected
  class Verification < Base

    def verify(params)
      Response::Verification.new request(:post, resource_path, params)
    end

    private
    def resource_path
      "/verification"
    end

  end
end
