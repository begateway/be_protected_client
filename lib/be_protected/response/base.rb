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
        response.body.nil? ? unknown_error : body["error"]
      end

      def success?
        (200..299).include?(status) ? true : false
      end

      def failed?
        !success?
      end

      protected
      def body
        @body ||= response.body.is_a?(Hash) ? response.body : {}
      end

      def unknown_error
        "Unknown response. Status is #{status}."
      end

    end
  end
end
