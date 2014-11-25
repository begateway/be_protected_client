module BeProtected
  module Response
    class Rule < Base

      key_reader :uuid, :account_uuid, :action, :condition,
      :alias, :active, :message, :created_at, for: :body

    end
  end
end
