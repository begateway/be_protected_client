module BeProtected
  module Response
    module Attributes

      def key_reader(*args)
        options = args.pop
        hash = options[:for] if options.is_a?(Hash)

        raise "Missing 'for' key. Example: key_reader :uuid, for: :body" if hash.nil?

        args.each do |key|         # key_reader :uuid, :token, for: :body
          define_method(key) do    # def uuid
            send(hash)[key.to_s]   #   body["uuid"]
          end                      # end
        end
      end

    end
  end
end
