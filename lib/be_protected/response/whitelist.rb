module BeProtected
  module Response
    class Whitelist < Base

      key_reader :value, :persisted, :message, for: :body

    end
  end
end
