require "be_protected/response/attributes"

module BeProtected
  module Response
    class Verification
      class Limit

        extend ::BeProtected::Response::Attributes

        attr_reader :attributes
        key_reader :max, :count, :volume, :current_volume, :current_count, :error, for: :attributes

        def initialize(attributes)
          @attributes = attributes
        end

        def passed?
          (max == false && count == false && volume == false) ||
            error?
        end

        def error?
          attributes.has_key?("error")
        end

        def to_hash
          {volume: volume, count: count, max: max,
            current_volume: current_volume, current_count: current_count}
        end

      end
    end
  end
end
