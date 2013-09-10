$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

# Include the Dwolla gem
require 'rubygems'
require 'pp'
require '../lib/dwolla'

# Include any required keys
require './_keys.rb'

# Instantiate a new Dwolla User client
Dwolla::api_key = @api_key
Dwolla::api_secret = @api_secret
Dwolla::debug = false

# Clear out any previous session data
Dwolla::OffsiteGateway.clear_session

# Optional Settings
Dwolla::OffsiteGateway.redirect = 'http://dwolla.com/payment_redirect'
Dwolla::OffsiteGateway.callback = 'http://dwolla.com/payment_callback'
Dwolla::OffsiteGateway.set_customer_info('Michael', 'Schonfeld', 'michael@dwolla.com', 'New York', 'NY', '10001')
Dwolla::OffsiteGateway.discount = 4.95
Dwolla::OffsiteGateway.notes = 'This is just an offsite gateway test...'

# Add products
Dwolla::OffsiteGateway.add_product('Macbook Air', '13" Macbook Air; Model #0001', 499.99, 1)

# Generate a checkout sesssion
pp Dwolla::OffsiteGateway.get_checkout_url('812-734-7288')

# Verify and parse gateway callback
data = Dwolla::OffsiteGateway.read_callback('{"Amount":0.01,"OrderId":null,"Status":"Completed","Error":null,"TransactionId":3396300,"CheckoutId":"51f9dfaa-20ed-41a7-8874-00a47c19c655","Signature":"8be03dfd0e95c567b2855f5876acfc98992f6402","TestMode":"false","ClearingDate":"7/22/2013 8:42:18 PM"}')
pp data
