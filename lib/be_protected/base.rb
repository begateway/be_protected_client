require 'json'
require 'faraday'
require 'faraday_middleware'

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

          connection.build do |builder|
            options[:connection_build].call(builder)
          end if options[:connection_build]

          connection.basic_auth(auth_login, auth_password)
          connection.request :json
          connection.response :json

          connection
        end
    end

    protected
    def request(method, path, params = nil)
      connection.send(method, path, params) do |req|
        if method == :post
          req.headers['Content-Type'] = 'application/json'
          req.body = params.to_json if params
        end
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
