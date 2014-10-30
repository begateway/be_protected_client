require "be_protected/response/attributes"

module BeProtected
  module Response
    class BaseList < Base

      include Enumerable

      attr_reader :items

      def initialize(*args)
        super
        set_items
      end

      def each(&block)
        items.each(&block)
      end

      def [](index)
        items[index]
      end

      private

      def set_items
        @items = []
        if response.body[root_key].is_a?(Array)
          response.body[root_key].each do |item|
            struct = OpenStruct.new(status: status, body: item)
            @items << item_class_name.new(struct)
          end
        end
      end

      def item_class_name
        raise 'Unknown item class name'
      end

      def root_key
        raise 'Unknown root key'
      end

    end
  end
end
