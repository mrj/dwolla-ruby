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
#   Fetch last 10 contacts from the 
#   account associated with the provided
#   OAuth token
contacts = Dwolla::Contacts.get
pp contacts


# EXAMPLE 2: 
#   Search through the contacts of the
#   account associated with the provided
#   OAuth token
contacts = Dwolla::Contacts.get({:search => 'Ben'})
pp contacts