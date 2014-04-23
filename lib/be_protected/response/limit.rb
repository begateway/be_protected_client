module BeProtected
  module Response
    class Limit < Base

      key_reader :uuid, :key, :max, :count, :volume, :message, for: :body

    end
  end
end
