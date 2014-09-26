require 'test/unit'
require 'mocha/test_unit'
require 'dwolla'

class AccountsTest < Test::Unit::TestCase
  def test_get_auto_withdrawal_status
    Dwolla.stubs(:request).with(:get, '/accounts/features/auto_withdrawl', {}, {}, 'abc')
    Dwolla::Accounts.get_auto_withdrawal_status('abc')
  end

  def test_toggle_auto_withdrawl
    Dwolla.stubs(:request).with(:post, '/accounts/features/auto_withdrawl',
                                {
                                    :enabled => true,
                                    :fundingId => '123456'
                                }, {}, 'abc')
    Dwolla::Accounts.toggle_auto_withdrawl(true, '123456', 'abc')
  end
end