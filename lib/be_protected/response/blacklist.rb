module BeProtected
  module Response
    class Blacklist < Base

      key_reader :value, :persisted, :message, for: :body

    end
  end
end
