module BeProtected
  module Response
    class Sets < BaseList

      private

      def item_class_name
        Response::Set
      end

    end
  end
end
