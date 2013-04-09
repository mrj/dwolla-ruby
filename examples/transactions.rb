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
#   Send money ($1.00) to a Dwolla ID 
transactionId = Dwolla::Transactions.send({:destinationId => '812-626-8794', :amount => 1.00, :pin => $pin})
pp transactionId

# EXAMPLE 2: 
#   Send money ($1.00) to an email address, with a note
transactionId = Dwolla::Transactions.send({:destinationId => '812-626-8794', :destinationType => 'Email', :amount => 1.00, :pin => $pin, :notes => 'Everyone loves getting money'})
pp transactionId

# EXAMPLE 3: 
#   Get details about all recent transactions
transactions = Dwolla::Transactions.get
pp transactions

# EXAMPLE 4: 
#   Get details about a certain Transaction
transactionId = Dwolla::Transactions.get(transactionId)
pp transactionId