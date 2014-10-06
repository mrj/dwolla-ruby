require 'test/unit'
require 'mocha/test_unit'
require 'dwolla'

class BalanceTest < Test::Unit::TestCase
  def test_balance
    Dwolla.stubs(:request).with(:get, '/balance/', {}, {}, 'abc')
    Dwolla::Balance.get('abc')
  end
end