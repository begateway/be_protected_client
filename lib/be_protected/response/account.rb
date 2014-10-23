module BeProtected
  module Response
    class Account < Base

      key_reader :uuid, :name, :token, :parent_uid, for: :body

    end
  end
end
