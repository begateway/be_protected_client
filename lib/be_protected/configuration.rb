module BeProtected
  class Configuration

    class << self
      attr_accessor :url, :proxy, :read_timeout, :open_timeout

      def setup
        yield self
      end
    end

  end
end
