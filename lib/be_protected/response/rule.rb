module BeProtected
  module Response
    class Rule < Base

      key_reader :uuid, :account_uuid, :action, :condition, :alias, for: :body

    end
  end
end
