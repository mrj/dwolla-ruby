require 'test/unit'
require 'mocha/test_unit'
require 'dwolla'

class OffsiteGatewayTest < Test::Unit::TestCase
  def test_add_product
    Dwolla::OffsiteGateway.add_product("Test", "Desc", 1.50, 2)
    assert Dwolla::OffsiteGateway.instance_variable_get(:@products) == [{:name => 'Test', :description => 'Desc', :price => 1.50, :quantity => 2}]
  end

  def test_set_customer_info
    Dwolla::OffsiteGateway.set_customer_info("First", "Last", "Em@i.l", "City", "State", "90210")
    assert Dwolla::OffsiteGateway.instance_variable_get(:@customerInfo) == {
        :firstName => "First",
        :lastName => "Last",
        :email => "Em@i.l",
        :city => "City",
        :state => "State",
        :zip => "90210"
    }
  end

  def test_discount
    Dwolla::OffsiteGateway.discount = 1
    assert Dwolla::OffsiteGateway.instance_variable_get(:@discount) == -1
  end

  def test_get_checkout_url
    Dwolla.stubs(:request).with(:post, 'https://www.dwolla.com/payment/request',
                                {
                                    :key => 'abc',
                                    :secret => 'def',
                                    :allowFundingSources => true,
                                    :additionalFundingSources => true,
                                    :test => false,
                                    :callback => nil,
                                    :redirect => nil,
                                    :orderId => nil,
                                    :notes => nil,
                                    :purchaseOrder => {
                                        :customerInfo => @customerInfo,
                                        :destinationId => '812-111-1234',
                                        :orderItems => [{:name => 'Test', :description => 'Desc', :price => 1.50, :quantity => 2}],
                                        :facilitatorAmount => nil,
                                        :discount => -1,
                                        :shipping => 0,
                                        :tax => 0,
                                        :total => 2.00
                                    }
                                }, {}, false, false, true)
    Dwolla::api_key = 'abc'
    Dwolla::api_secret = 'def'
    Dwolla::OffsiteGateway.get_checkout_url('812-111-1234')
  end

  ## TODO: Tests to validate OpenSSL digest functionality.

end