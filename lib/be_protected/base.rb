require 'json'
require 'faraday'
require 'faraday_middleware'
require "be_protected/middleware"

module BeProtected
  class Base

    attr_reader :auth_login, :auth_password, :options, :passed_headers

    def initialize(opts = {}, &block)
      @auth_login    = opts[:auth_login]
      @auth_password = opts[:auth_password]
      @passed_headers= opts[:headers]
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
          connection.use BeProtected::Middleware::ParseJson

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
    rescue Faraday::Error => e
      response = OpenStruct.new(status: 500, body: { 'error' => e.to_s } )
      Response::Base.new(response)
    end

    private
    def connection_opts
      (options[:connection_opts] || {}).tap do |opts|
        opts[:proxy] = Configuration.proxy if Configuration.proxy
        opts[:headers] = passed_headers if passed_headers
        # timeouts
        opts[:request] = opts[:request] || {}
        opts[:request].update(timeout: read_timeout)      unless opts.dig(:request, :timeout)
        opts[:request].update(open_timeout: open_timeout) unless opts.dig(:request, :open_timeout)
      end
    end

    def site_url
      Configuration.url
    end

    def read_timeout
      Configuration.read_timeout || 60
    end

    def open_timeout
      Configuration.open_timeout || 60
    end

  end
end
