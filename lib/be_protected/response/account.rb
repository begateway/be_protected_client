module BeProtected
  module Response
    class Account < Base

      key_reader :uuid, :name, :token, for: :body

    end
  end
end
