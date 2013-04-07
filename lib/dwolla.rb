# Dwolla Ruby API Wrapper
# API spec at https://developers.dwolla.com
require 'openssl'
require 'rest_client'
require 'multi_json'
require 'addressable/uri'

# Version
require 'dwolla/version'

# Resources
require 'dwolla/json'
require 'dwolla/transactions'
require 'dwolla/requests'
require 'dwolla/contacts'
require 'dwolla/users'
require 'dwolla/balance'
require 'dwolla/funding_sources'

# Errors
require 'dwolla/errors/dwolla_error'
require 'dwolla/errors/api_connection_error'
require 'dwolla/errors/api_error'
require 'dwolla/errors/missing_parameter_error'
require 'dwolla/errors/authentication_error'
require 'dwolla/errors/invalid_request_error'

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

    def self.api_version=(api_version)
        @@api_version = api_version
    end

    def self.api_version
        @@api_version
    end

    def self.verify_ssl_certs=(verify_ssl_certs)
        @@verify_ssl_certs = verify_ssl_certs
    end

    def self.verify_ssl_certs
        @@verify_ssl_certs
    end

    def self.token=(token)
        @@token = token
    end

    def self.token
        @@token
    end

    def self.endpoint_url(endpoint)
        @@api_base + endpoint
    end

    def self.request(method, url, params={}, headers={}, oauth=true)
        if oauth
            raise AuthenticationError.new('No OAuth Token Provided.') unless token
            params = {
                :oauth_token => token
            }.merge(params)
        else
            raise AuthenticationError.new('No App Key & Secret Provided.') unless (api_key && api_secret)
            params = {
                :client_id => api_key,
                :client_secret => api_secret
            }.merge(params)
        end

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

        url = self.endpoint_url(url)

        case method.to_s.downcase.to_sym
            when :get
                # Make params into GET parameters
                if params && params.count > 0
                    uri = Addressable::URI.new
                    uri.query_values = params
                    url += '?' + uri.query
                end
                payload = nil
            else
                payload = ''
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
            :user_agent => "Dwolla Ruby API Wrapper/#{Dwolla::VERSION}",
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

        begin
            response = execute_request(opts)
        rescue SocketError => e
            self.handle_restclient_error(e)
        rescue NoMethodError => e
            # Work around RestClient bug
            if e.message =~ /\WRequestFailed\W/
                e = APIConnectionError.new('Unexpected HTTP response code')
                self.handle_restclient_error(e)
            else
                raise
            end
        rescue RestClient::ExceptionWithResponse => e
            if rcode = e.http_code and rbody = e.http_body
                self.handle_api_error(rcode, rbody)
            else
                self.handle_restclient_error(e)
            end
        rescue RestClient::Exception, Errno::ECONNREFUSED => e
            self.handle_restclient_error(e)
        end

        rbody = response.body
        rcode = response.code

        self.parse_response(rbody, rcode)
    end

    private
 
    def self.execute_request(opts)
        RestClient::Request.execute(opts)
    end

    def self.parse_response(rbody, rcode)
        begin
            resp = Dwolla::JSON.load(rbody)
            raise APIError.new(resp['Message']) unless resp['Success']
        rescue MultiJson::DecodeError
            raise APIError.new("There was an error parsing Dwolla's API response: #{rbody.inspect} (HTTP response code was #{rcode})", rcode, rbody)
        end

        return resp['Response']
    end

    def self.handle_api_error(rcode, rbody)
        begin
            error_obj = Dwolla::JSON.load(rbody)
            error = error_obj[:error] or raise DwollaError.new # escape from parsing
        rescue MultiJson::DecodeError, DwollaError
            raise APIError.new("Invalid response object from API: #{rbody.inspect} (HTTP response code was #{rcode})", rcode, rbody)
        end

        case rcode
            when 400, 404 then
                raise invalid_request_error(error, rcode, rbody, error_obj)
            when 401
                raise authentication_error(error, rcode, rbody, error_obj)
            else
                raise api_error(error, rcode, rbody, error_obj)
        end
    end

    def self.invalid_request_error(error, rcode, rbody, error_obj)
        InvalidRequestError.new(error[:message], error[:param], rcode, rbody, error_obj)
    end

    def self.authentication_error(error, rcode, rbody, error_obj)
        AuthenticationError.new(error[:message], rcode, rbody, error_obj)
    end

    def self.api_error(error, rcode, rbody, error_obj)
        APIError.new(error[:message], rcode, rbody, error_obj)
    end


    def self.handle_restclient_error(e)
        case e
        when RestClient::ServerBrokeConnection, RestClient::RequestTimeout
            message = "Could not connect to Dwolla (#{@@api_base}).  Please check your internet connection and try again.  If this problem persists, you should check Dwolla's service status at https://twitter.com/Dwolla, or let us know at support@Dwolla.com."
        when RestClient::SSLCertificateNotVerified
            message = "Could not verify Dwolla's SSL certificate. If this problem persists, let us know at support@dwolla.com."
        when SocketError
            message = "Unexpected error communicating when trying to connect to Dwolla. If this problem persists, let us know at support@dwolla.com."
        else
            message = "Unexpected error communicating with Dwolla. If this problem persists, let us know at support@dwolla.com."
        end
            message += "\n\n(Network error: #{e.message})"
        raise APIConnectionError.new(message)
    end
end