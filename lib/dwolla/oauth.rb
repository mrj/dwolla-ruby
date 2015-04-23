module Dwolla
  class OAuth
    def self.get_auth_url(redirect_uri=nil, scope=Dwolla::scope)
      raise AuthenticationError.new('No Api Key Provided.') unless Dwolla::api_key

      params = {
          :scope => scope,
          :response_type => 'code',
          :client_id => Dwolla::api_key
      }

      params['redirect_uri'] = redirect_uri unless redirect_uri.nil?

      uri = Addressable::URI.new
      uri.query_values = params

      if Dwolla::debug and Dwolla::sandbox
        puts "[DWOLLA SANDBOX MODE OPERATION]"
      end

      return auth_url + '?' + uri.query
    end

    def self.get_token(code=nil, redirect_uri=nil)
      raise MissingParameterError.new('No Code Provided.') if code.nil?

      params = {
          :grant_type => 'authorization_code',
          :code => code
      }

      # I realize this is ugly, but the unit tests fail
      # if the key is accessed["like_this"] because the
      # hash is compared with "quotes" and not :like_this.

      # It may very well be my Ruby version
      # TODO: Revisit this
      (params = params.merge({:redirect_uri => redirect_uri})) unless redirect_uri.nil?

      resp = Dwolla.request(:post, token_url, params, {}, false, false, true)

      # TODO: Revisit this to make it more unit test friendly, fails ['error_description'] due to
      # key not existing, same on L58
      return "No data received." unless resp.is_a?(Hash)
      raise APIError.new(resp['error_description']) unless resp.has_key?('access_token') and resp.has_key?('refresh_token')

      return resp
    end

    def self.refresh_auth(refresh_token=nil)
      raise MissingParameterError.new('No Refresh Token Provided') if refresh_token.nil?

      params = {
          :grant_type => 'refresh_token',
          :refresh_token => refresh_token
      }

      resp = Dwolla.request(:post, token_url, params, {}, false, false, true)

      return "No data received." unless resp.is_a?(Hash)
      raise APIError.new(resp['error_description']) unless resp.has_key?('access_token') and resp.has_key?('refresh_token')

      return resp
    end

    def self.catalog(token=nil)
      resp = Dwolla.request(:get, '/catalog', {}, {}, token, false, false)

      raise APIError.new(resp['Message']) if !resp['Success']
      return resp['_links']
    end

    private

    def self.auth_url
      Dwolla.hostname + '/oauth/v2/authenticate'
    end

    def self.token_url
      Dwolla.hostname + '/oauth/v2/token'
    end
  end
end