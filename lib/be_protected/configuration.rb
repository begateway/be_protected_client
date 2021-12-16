module BeProtected
  class Configuration

    class << self
      attr_accessor :url, :proxy, :read_timeout, :open_timeout, :ssl

      def setup
        yield self
      end
    end

  end
end
