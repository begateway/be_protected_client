require "be_protected/response/attributes"

module BeProtected
  module Response
    class Base
      extend ::BeProtected::Response::Attributes

      attr_reader :response

      def initialize(response)
        @response = response
      end

      def status
        response.status
      end

      def error
        body["error"]
      end

      def success?
        (200..299).include?(status) ? true : false
      end

      def failed?
        !success?
      end

      def raw
        body['raw_response'] || body.to_json
      end

      protected
      def body
        @body ||= response.body.is_a?(Hash) ? response.body : {}
      end

    end
  end
end
