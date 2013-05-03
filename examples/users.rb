# Include the Dwolla gem
require 'rubygems'
require 'pp'
require 'dwolla'

# Include any required keys
require '_keys.rb'

# Instantiate a new Dwolla User client
# And, seed a previously generated access token
Dwolla::token = @token
Dwolla::api_key = @api_key
Dwolla::api_secret = @api_secret

# EXAMPLE 1:
#   Fetch account information for the
#   account associated with the provided
#   OAuth token
pp Dwolla::Users.get


# EXAMPLE 2: 
#   Fetch basic account information
#   for a given Dwolla ID
pp Dwolla::Users.get('812-626-8794')


# EXAMPLE 3: 
#   Fetch basic account information
#   for a given Email address
pp Dwolla::Users.get('michael@dwolla.com')