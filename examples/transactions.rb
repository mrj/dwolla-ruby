# Include the Dwolla gem
require 'rubygems'
require 'pp'
require '../lib/dwolla'

# Include any required keys
require './_keys.rb'

# Instantiate a new Dwolla User client
# And, seed a previously generated access token
Dwolla::token = @token
Dwolla::debug = true

# EXAMPLE 1:
#   Send money ($1.00) to a Dwolla ID
transactionId = Dwolla::Transactions.send({:destinationId => '812-626-8794', :amount => 1.00, :pin => @pin})
pp transactionId

# EXAMPLE 2:
#   Send money ($1.00) to an email address, with a note
transactionId = Dwolla::Transactions.send({:destinationId => '812-626-8794', :destinationType => 'Email', :amount => 1.00, :pin => @pin, :notes => 'Everyone loves getting money'})
pp transactionId

# EXAMPLE 3:
#   Get details about all recent transactions
pp Dwolla::Transactions.get

# EXAMPLE 4:
#   Get details about a certain Transaction
pp Dwolla::Transactions.get(transactionId)

# EXAMPLE 4:
#   Get details about a certain Transaction
#   using the API key & secret
Dwolla::token = ''
Dwolla::api_key = @api_key
Dwolla::api_secret = @api_secret
pp Dwolla::Transactions.get(transactionId, {}, false)
