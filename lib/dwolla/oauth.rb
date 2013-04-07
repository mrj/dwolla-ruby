module Dwolla
    class OAuth
        def self.get_auth_url(redirect_uri=nil, scope='send|transactions|balance|request|contacts|accountinfofull|funding')
            raise AuthenticationError.new('No Api Key Provided.') unless Dwolla::api_key

            params = {
                :scope => scope,
                :response_type => 'code',
                :client_id => Dwolla::api_key
            }

            params['redirect_uri'] = redirect_uri unless redirect_uri.nil?

            uri = Addressable::URI.new
            uri.query_values = params

            return auth_url + '?' + uri.query
        end

        def self.get_token(code=nil, redirect_uri=nil)
            raise MissingParameterError.new('No Code Provided.') if code.nil?

            params = {
                :grant_type => 'authorization_code',
                :code => code
            }

            params['redirect_uri'] = redirect_uri unless redirect_uri.nil?

            Dwolla.request(:get, token_url, params, {}, false, false)['access_token']
        end

        private

        def self.auth_url
            return 'https://www.dwolla.com/oauth/v2/authenticate'
        end

        def self.token_url
            return 'https://www.dwolla.com/oauth/v2/token'
        end
    end
end
