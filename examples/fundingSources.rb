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
#   Fetch all funding sources for the
#   account associated with the provided
#   OAuth token
pp Dwolla::FundingSources.get


# EXAMPLE 2: 
#   Fetch detailed information for the
#   funding source with a specific ID
pp Dwolla::FundingSources.get('funding_source_id')

# EXAMPLE 3:
#   Deposit funds from a funding source (bank account)
#   into the Dwolla account balance.
pp Dwolla::FundingSources.deposit('funding_source_id', {:amount => 12.95, :pin => @pin})

# EXAMPLE 4:
#   Withdraw funds from a Dwolla account balance into
#   a funding source (bank account)
pp Dwolla::FundingSources.withdraw('funding_source_id', {:amount => 12.95, :pin => @pin})

# EXAMPLE 5:
#   Add a new funding source (bank account).
#   Possible values for account_type: "Checking" and "Savings"
pp Dwolla::FundingSources.add({:routing_number => 99999999, :account_number => 99999999, :account_type => "Checking", :name => "Some Nickname"})
