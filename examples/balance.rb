# Include the Dwolla gem
require 'rubygems'
require 'pp'
require 'dwolla'

# Include any required keys
require './_keys.rb'

# Instantiate a new Dwolla User client
# And, seed a previously generated access token
Dwolla::token = @token


# EXAMPLE 1: 
#   Get the balance of the authenticated user
pp Dwolla::Balance.get