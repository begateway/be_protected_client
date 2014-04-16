module BeProtected
  class Limit < Base

    def create(params)
      Response::Limit.new request(:post, "/limits", params)
    end

  end
end
