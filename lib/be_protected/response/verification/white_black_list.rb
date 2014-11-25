require "be_protected/response/attributes"

module BeProtected
  module Response
    class Verification
      class WhiteBlackList

        extend ::BeProtected::Response::Attributes

        attr_reader :attributes
        key_reader :error, for: :attributes

        def initialize(attributes)
          @attributes = attributes
        end

        def passed?
          any_attribute_equal_white? || all_attribute_equal_absent? || error?
        end

        def error?
          attributes.has_key?("error")
        end

        def to_hash
          return {} if error?

          {}.tap do |hash|
            attributes.each_pair do |key, value|
              hash[key.to_sym] = value
            end
          end
        end

        def method_missing(name, *args, &block)
          if attributes.keys.include?(name.to_s)
            attributes[name.to_s]
          else
            super
          end
        end

        private

        def any_attribute_equal_white?
          attributes.any? {|key, value| value == "white"}
        end

        def all_attribute_equal_absent?
          attributes.all? {|key, value| value == "absent"}
        end

      end
    end
  end
end
