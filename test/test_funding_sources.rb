require 'test/unit'
require 'mocha/test_unit'
require 'dwolla'

class FundingSourcesTest < Test::Unit::TestCase
  def test_get
    Dwolla.stubs(:request).with(:get, '/fundingsources/123456', {}, {}, 'abc')
    Dwolla::FundingSources.get('123456', 'abc')
  end

  def test_withdraw
    Dwolla.stubs(:request).with(:post, '/fundingsources/123456/withdraw',
                                {
                                    :pin => 1337,
                                    :amount => 13.37
                                }, {}, 'abc')
    Dwolla::FundingSources.withdraw('123456',
                                    {
                                        :pin => 1337,
                                        :amount => 13.37
                                    }, 'abc')
  end

  def test_deposit
    Dwolla.stubs(:request).with(:post, '/fundingsources/123456/deposit',
                                {
                                    :pin => 1337,
                                    :amount => 13.37
                                }, {}, 'abc')
    Dwolla::FundingSources.deposit('123456',
                                   {
                                       :pin => 1337,
                                       :amount => 13.37
                                   }, 'abc')
  end

  def test_add
    Dwolla.stubs(:request).with(:post, '/fundingsources/',
                                  {
                                      :account_number => '123456',
                                      :routing_number => '654321',
                                      :account_type => 'Checking',
                                      :name => 'My Unit Testing Account'
                                  }, {}, 'abc')
    Dwolla::FundingSources.add({
                                   :account_number => '123456',
                                   :routing_number => '654321',
                                   :account_type => 'Checking',
                                   :name => 'My Unit Testing Account'
                               }, 'abc')
  end

  def test_verify
    Dwolla.stubs(:request).with(:post, '/fundingsources/123456/verify',
                                {
                                    :deposit1 => 0.05,
                                    :deposit2 => 0.08
                                }, {}, 'abc')
    Dwolla::FundingSources.verify('123456',
                                  {
                                      :deposit1 => 0.05,
                                      :deposit2 => 0.08
                                  }, 'abc')
  end
end