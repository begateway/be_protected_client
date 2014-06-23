require "be_protected/response/attributes"

module BeProtected
  module Response
    class Verification
      class Blacklist

        extend ::BeProtected::Response::Attributes

        attr_reader :attributes
        key_reader :error, for: :attributes

        def initialize(attributes)
          @attributes = attributes
        end

        def passed?
          all_attributes_equal_false? || error?
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
        def all_attributes_equal_false?
          attributes.all? {|key, value| value == false}
        end

      end
    end
  end
end
