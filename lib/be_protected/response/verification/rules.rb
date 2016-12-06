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
          !has_action?('reject')
        end

        def has_action?(action)
          attributes.values.each do |account_result|
            account_result.values.each do |rules_result|
              return true if rules_result.values.include?(action)
            end
          end
          false
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
