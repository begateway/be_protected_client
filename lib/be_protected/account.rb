module BeProtected
  class Account < Base

    def create(name)
      Response::Account.new request(:post, "/accounts", {name: name})
    end

  end
end
