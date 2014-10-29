require "be_protected/response/attributes"

module BeProtected
  module Response
    class BaseList < Base

      def initialize(*args)
        @items = []
        super
      end

      def [](index)
        @items[index] ||=
          begin
            value = item_from_response(index)
            struct = OpenStruct.new(status: status, body: value)
            item_class_name.new(struct)
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

      def item_class_name
        raise 'Unknown item class name'
      end

    end
  end
end
