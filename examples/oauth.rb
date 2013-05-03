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
#   a never-expiring OAuth access token
get '/oauth_return' do
    code = params['code']
    token = Dwolla::OAuth.get_token(code, redirect_uri)
    "Your never-expiring OAuth access token is: <b>#{token}</b>"
end
