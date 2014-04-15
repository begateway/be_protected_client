require 'faraday'

module BeProtected
  class Base

    attr_reader :auth_login, :auth_password, :options

    def initialize(opts = {}, &block)
      @auth_login    = opts[:auth_login]
      @auth_password = opts[:auth_password]
      @options = {
        connection_opts:  opts[:connection_opts],
        connection_build: block
     }
    end

    def connection
      @connection ||=
        begin
          connection = Faraday.new(site_url, connection_opts)
          connection.build do |b|
            options[:connection_build].call(b)
          end if options[:connection_build]

          connection
        end
    end

    private
    def connection_opts
      (options[:connection_opts] || {}).tap do |opts|
        opts[:proxy] = Configuration.proxy if Configuration.proxy
      end
    end

    def site_url
      Configuration.url
    end

  end
end
