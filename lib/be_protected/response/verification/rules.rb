require "be_protected/response/attributes"

module BeProtected
  module Response
    class Verification
      class Rules

        extend ::BeProtected::Response::Attributes

        attr_reader :attributes

        def initialize(attributes)
          @attributes = attributes
        end

        def passed?
          attributes.keys.each do |account|
            attributes[account].keys.each do |alias_name|
              return false if attributes[account][alias_name].values.include?('reject')
            end
          end
          true
        end

        def error?
          attributes.has_key?("error")
        end

        def to_hash
          attributes
        end

      end
    end
  end
end
