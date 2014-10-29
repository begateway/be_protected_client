module BeProtected
  module Response
    class Set < Base

      key_reader :uuid, :account_uuid, :name, :value, for: :body

    end
  end
end
