# Include the Dwolla gem
require 'rubygems'
require 'pp'
require 'sinatra'
require 'dwolla'

# Include any required keys
require './_keys.rb'

# Instantiate a new Dwolla User client
Dwolla::api_key = @api_key
Dwolla::api_secret = @api_secret

# Constants...
redirect_uri = 'http://localhost:4567/oauth_return'

# STEP 1:
#   Create an authentication URL
#   that the user will be redirected to
get '/' do
  authUrl = Dwolla::OAuth.get_auth_url(redirect_uri)
  "To begin the OAuth process, send the user off to <a href=\"#{authUrl}\">#{authUrl}</a>"
end


# STEP 2:
#   Exchange the temporary code given
#   to us in the querystring, for
#   an expiring OAuth access token and refresh token pair.
get '/oauth_return' do
  code = params['code']
  info = Dwolla::OAuth.get_token(code, redirect_uri)
  token = info['access_token']
  refresh_token = info['refresh_token']
  "Your expiring OAuth access token is: <b>#{token}</b>, and your refresh token is <b>#{refresh_token}</b>"
end

# STEP 3:
#
#   The array returned in step 2 as 'info' also contains
#   expiration times for when the OAuth token will become
#   invalid. Use this method to refresh your token with
#   the provided refresh token.
#
get '/oauth_refresh' do
  refresh_token = params['refresh_token']
  info = Dwolla::OAuth.refresh_auth(refresh_token)
  token = info['access_token']
  refresh_token = info['refresh_token']
  "Your expiring OAuth access token is: <b>#{token}</b>, and your refresh token is <b>#{refresh_token}</b>"
end

# STEP 4: View the endpoints elligible for use with
# the passed OAuth token.
#
get '/catalog' do
  token = params['token']
  catalog = Dwolla::OAuth.catalog(token)
  "The endpoints available for use with this token are #{catalog}"
end