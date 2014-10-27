module BeProtected
  module Response
    class Verification < Base
      autoload :Limit, 'be_protected/response/verification/limit'
      autoload :Rules, 'be_protected/response/verification/rules'
      autoload :Blacklist, 'be_protected/response/verification/blacklist'

      def passed?
        verifications.any? && verifications.values.all?(&:passed?)
      end

      def error?
        verifications.any? && verifications.values.any?(&:error?)
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
              errors << (key.capitalize << ": " << verifications[key].error)
            end
          end
        end.join(" ")
      end

      def limit
        verifications["limit"]
      end

      def blacklist
        verifications["blacklist"]
      end

      def rules
        verifications["rules"]
      end

      private
      def verifications
        @verifications ||= success? ? verification_hash : {}
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

        self.class.const_get(key.capitalize.to_sym).new(verification_params)
      end

      def verification_defined?(key)
        self.class.const_defined?(key.capitalize)
      end

    end
  end
end
