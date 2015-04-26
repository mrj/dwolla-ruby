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

# EXAMPLE 5:
#   Get details about a certain Transaction
#   using the API key & secret
Dwolla::token = ''
Dwolla::api_key = @api_key
Dwolla::api_secret = @api_secret
pp Dwolla::Transactions.get(transactionId, {}, false)

# EXAMPLE 6: 
#   Send money ($1.00) to a Dwolla ID
#   on 2015-09-09 from funding source "abcdef"
pp Dwolla::Transactions.schedule({
                                :pin => @pin,
                                :amount => 1.00,
                                :destinationId => '812-111-1111',
                                :fundsSource => 'abcdef',
                                :scheduleDate => '2015-09-09'}) 


# EXAMPLE 7: 
#   Get all scheduled transactions
pp Dwolla::Transactions.scheduled() 

# EXAMPLE 8: 
#   Get scheduled transaction with ID
#   'abcd214'
pp Dwolla::Transactions.scheduled_by_id('abcd214') 

# EXAMPLE 9: 
#   Edit scheduled transaction with ID 
#   'abcd123' to have new amount 10.50
pp Dwolla::Transactions.edit_scheduled_by_id('abcd123', {:amount => 10.50})

# EXAMPLE 10: 
#   Delete the scheduled transaction with ID 
#   'abcd123' 
pp Dwolla::Transactions.delete_scheduled_by_id('abcd123', {:pin => @pin})

# EXAMPLE 11: 
#   Delete all scheduled transactions 
pp Dwolla::Transactions.delete_all_scheduled('abcd123', {:pin => @pin})