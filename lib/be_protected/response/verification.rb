module BeProtected
  module Response
    class Verification < Base
      autoload :Limit, 'be_protected/response/verification/limit'
      autoload :Rules, 'be_protected/response/verification/rules'
      autoload :WhiteBlackList, 'be_protected/response/verification/white_black_list'

      def passed?
        verifications.any? && verifications.values.all?(&:passed?)
      end

      def error?
        verifications.any? && verifications.values.any?(&:error?)
      end

      def has_action?(action)
        rules && rules.has_action?(action)
      end

      def to_hash
        {}.tap do |hash|
          verifications.keys.each do |key|
            hash[key.to_sym] = verifications[key].to_hash
          end
        end
      end

      def error_messages
        [].tap do |errors|
          errors << error if error

          verifications.keys.each do |key|
            if verifications[key].error?
              errors << (camelize(key) << ": " << verifications[key].error)
            end
          end
        end.join(" ")
      end

      def limit
        verifications["limit"]
      end

      def white_black_list
        verifications["white_black_list"]
      end

      def rules
        verifications["rules"]
      end

      private
      def verifications
        @verifications ||= (success? ? verification_hash : {})
      end

      def verification_hash
        {}.tap do |hash|
          body.keys.each do |key|
            hash[key] = build_verification_result(key) if verification_defined?(key)
          end
        end
      end

      def build_verification_result(key)
        verification_params = body[key]

        self.class.const_get(camelize(key)).new(verification_params)
      end

      def verification_defined?(key)
        self.class.const_defined?(camelize(key))
      end

      def camelize(string)
        string.split(/_/).map(&:capitalize).join
      end

    end
  end
end
