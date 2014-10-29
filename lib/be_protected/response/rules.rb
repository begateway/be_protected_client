module BeProtected
  module Response
    class Rules < BaseList

      private

      def item_class_name
        Response::Rule
      end

    end
  end
end
