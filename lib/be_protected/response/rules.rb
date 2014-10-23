require "be_protected/response/attributes"

module BeProtected
  module Response
    class Rules < Base

      def initialize(*args)
        @items = []
        super
      end

      def [](index)
        @items[index] ||=
          begin
            value = item_from_response(index)
            struct = OpenStruct.new(status: status, body: value)
            Response::Rule.new(struct)
          end
      end

      private

      def item_from_response(index)
        if response.body.is_a?(Array)
          response.body[index]
        else
          {}
        end
      end

    end
  end
end
