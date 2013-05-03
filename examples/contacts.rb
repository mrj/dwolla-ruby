# Include the Dwolla gem
require 'rubygems'
require 'pp'
require 'dwolla'

# Include any required keys
require './_keys.rb'

# Instantiate a new Dwolla User client
# And, seed a previously generated access token
Dwolla::token = @token
Dwolla::api_key = @api_key
Dwolla::api_secret = @api_secret


# EXAMPLE 1: 
#   Fetch last 10 contacts from the 
#   account associated with the provided
#   OAuth token
pp Dwolla::Contacts.get


# EXAMPLE 2: 
#   Search through the contacts of the
#   account associated with the provided
#   OAuth token
pp Dwolla::Contacts.get({:search => 'Ben'})


# EXAMPLE 3: 
#   Get a list of nearby Dwolla spots
#   for a given set of coordinates
pp Dwolla::Contacts.nearby({:latitude => 1, :longitude => 2})