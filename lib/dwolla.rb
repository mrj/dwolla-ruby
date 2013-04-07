# Dwolla Ruby API Wrapper
# API spec at https://developers.dwolla.com
require 'openssl'
require 'rest_client'
require 'multi_json'

# Version
require 'dwolla/version'

# Resources
require 'dwolla/transactions'

# Errors
require 'dwolla/error'

module Dwolla
    @@api_key = nil
    @@api_secret = nil
    @@token = nil
    @@api_base = 'https://www.dwolla.com/oauth/rest'
    @@verify_ssl_certs = true
    @@api_version = nil
    @@debug = false

    def self.api_key=(api_key)
        @@api_key = api_key
    end

    def self.api_key
        @@api_key
    end

    def self.api_secret=(api_secret)
        @@api_secret = api_secret
    end

    def self.api_secret
        @@api_secret
    end

    def self.token=(token)
        @@token = token
    end

    def self.token
        @@token
    end

    def self.endpoint_url=(endpoint)
        @@api_base + endpoint
    end

    def self.request=(method, url, token, params={}, headers={})
        token ||= @@token
        raise AuthenticationError.new('No OAuth Token Provided.') unless token

        if !verify_ssl_certs
            $stderr.puts "WARNING: Running without SSL cert verification."
        else
            ssl_opts = {
                :verify_ssl => OpenSSL::SSL::VERIFY_PEER
            }
        end
        
        uname = (@@uname ||= RUBY_PLATFORM =~ /linux|darwin/i ? `uname -a 2>/dev/null`.strip : nil)
        lang_version = "#{RUBY_VERSION} p#{RUBY_PATCHLEVEL} (#{RUBY_RELEASE_DATE})"
        ua = {
            :bindings_version => Dwolla::VERSION,
            :lang => 'ruby',
            :lang_version => lang_version,
            :platform => RUBY_PLATFORM,
            :publisher => 'dwolla',
            :uname => uname
        }

        params = Util.objects_to_ids(params)
        url = self.endpoint_url(url)

        case method.to_s.downcase.to_sym
            when :get
                # Make params into GET parameters
                if params && params.count > 0
                    query_string = Util.flatten_params(params).collect{|key, value| "#{key}=#{Util.url_encode(value)}"}.join('&')
                    url += "#{URI.parse(url).query ? '&' : '?'}#{query_string}"
                end
                payload = nil
            else
                payload = Util.flatten_params(params).collect{|(key, value)| "#{key}=#{Util.url_encode(value)}"}.join('&')
        end

        begin
            headers = { :x_dwolla_client_user_agent => Dwolla::JSON.dump(ua) }.merge(headers)
        rescue => e
            headers = {
                :x_dwolla_client_raw_user_agent => ua.inspect,
                :error => "#{e} (#{e.class})"
            }.merge(headers)
        end

        headers = {
            :user_agent => "Dwolla RubyBindings/#{Dwolla::VERSION}",
            :content_type => 'application/json'
        }.merge(headers)

        if self.api_version
            headers[:dwolla_version] = self.api_version
        end

        opts = {
            :method => method,
            :url => url,
            :headers => headers,
            :open_timeout => 30,
            :payload => payload,
            :timeout => 80
        }.merge(ssl_opts)

        response = execute_request(opts)
        rbody = response.body
        rcode = response.code
        begin
            resp = Stripe::JSON.load(rbody)
        rescue MultiJson::DecodeError
            raise APIError.new("Invalid response object from API: #{rbody.inspect} (HTTP response code was #{rcode})", rcode, rbody)
        end

        resp = Util.symbolize_names(resp)
        [resp, api_key]
    end

    private
        def self.execute_request(opts)
            RestClient::Request.execute(opts)
        end

        def self.authentication_error(error, rcode, rbody, error_obj)
            AuthenticationError.new(error[:message], rcode, rbody, error_obj)
        end
    end
end