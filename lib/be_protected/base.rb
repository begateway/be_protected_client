require 'json'
require 'faraday'
require 'faraday_middleware'
require 'be_protected/middleware'

module BeProtected
  class Base

    attr_reader :auth_login, :auth_password, :connection_opts, :passed_headers

    def initialize(opts = {}, &block)
      @auth_login      = opts[:auth_login]
      @auth_password   = opts[:auth_password]
      @passed_headers  = opts[:headers]
      @connection_opts = opts[:connection_opts]
    end

    def connection
      @connection ||= Faraday.new(site_url, options) do |faraday|
        faraday.request :basic_auth, auth_login, auth_password
        faraday.request :json
        faraday.use BeProtected::Middleware::ParseJson
        faraday.adapter Faraday.default_adapter
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
    rescue => e # as in new version they added a lot of error classes
      response = OpenStruct.new(status: 500, body: { 'error' => e.to_s } )
      Response::Base.new(response)
    end

    private

    def options
      (connection_opts || {}).tap do |opts|
        opts[:proxy] = Configuration.proxy if Configuration.proxy
        opts[:headers] = passed_headers if passed_headers
        # timeouts
        opts[:request] = opts[:request] || {}
        opts[:request].update(timeout: read_timeout)      unless opts.dig(:request, :timeout)
        opts[:request].update(open_timeout: open_timeout) unless opts.dig(:request, :open_timeout)
        # ssl
        opts[:ssl] = Configuration.ssl if Configuration.ssl
      end
    end

    def site_url
      Configuration.url
    end

    def read_timeout
      Configuration.read_timeout || 15
    end

    def open_timeout
      Configuration.open_timeout || 5
    end

  end
end
