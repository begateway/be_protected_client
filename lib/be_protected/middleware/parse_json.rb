require 'faraday'
require 'json'

module BeProtected
  module Middleware
    class ParseJson < Faraday::Response::Middleware

      def parse(body)
        @parse ||= JSON.parse(body)
      end

      def on_complete(response)
        response.body = json?(response.body) ? parse(response.body) : error_response(response)
      end

      private
      def json?(body)
        begin
          return false unless body.is_a?(String)
          parse(body).all?
        rescue JSON::ParserError
          false
        end
      end

      def error_response(response)
        {'error' => "Response is not JSON. Status is #{response.status}.",
          'raw_response' => response.body}
      end
    end

  end
end
