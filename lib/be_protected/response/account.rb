module BeProtected
  module Response
    class Account < Base

      key_reader :uuid, :name, :token, :parent_uuid, for: :body

    end
  end
end
