# Include the Dwolla gem
require 'rubygems'
require 'pp'
require 'dwolla'

# Include any required keys
require '_keys.rb'

# Instantiate a new Dwolla User client
# And, seed a previously generated access token
Dwolla::token = $token


# EXAMPLE 1: 
#   Fetch all funding sources for the
#   account associated with the provided
#   OAuth token
sources = Dwolla::FundingSources.get
pp sources


# EXAMPLE 2: 
#   Fetch detailed information for the
#   funding source with a specific ID
source = Dwolla::FundingSources.get('pJRq4tK38fiAeQ8xo2iH9Q==')
pp source