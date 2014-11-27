module BeProtected
  class Verification < Base

    def verify(params)
      Response::Verification.new request(:post, resource_path, params)
    end

    def white_black_list_verify(value)
      params = {white_black_list: {value: value}}
      response = Response::Verification.new request(:post, resource_path, params)

      if response.failed? or response.error?
        nil
      else
        response.white_black_list.to_hash[:value]
      end
    end

    private
    def resource_path
      "/verification"
    end

  end
end
