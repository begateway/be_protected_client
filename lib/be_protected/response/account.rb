module BeProtected
  module Response
    class Account < Base

      def uuid
        body["uuid"]
      end

      def name
        body["name"]
      end

      def token
        body["token"]
      end

    end
  end
end
