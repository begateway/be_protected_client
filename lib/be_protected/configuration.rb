module BeProtected
  class Configuration

    class << self
      attr_accessor :url, :proxy

      def setup
        yield self
      end
    end

  end
end
