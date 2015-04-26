require 'test/unit'
require 'mocha/test_unit'
require 'dwolla'

class TransactionsTest < Test::Unit::TestCase
  def test_get
    Dwolla.stubs(:request).with(:get, '/transactions/', {:limit => 10}, {}, 'abc')
    Dwolla::Transactions.get({:limit => 10}, {}, 'abc')
  end

  def test_get_by_id
    Dwolla.stubs(:request).with(:get, '/transactions/123456', {}, {}, 'abc')
    Dwolla::Transactions.get('123456', {}, 'abc')
  end

  def test_stats
    Dwolla.stubs(:request).with(:get, '/transactions/stats', {:types => 'TransactionsCount'}, {}, 'abc')
    Dwolla::Transactions.stats({:types => 'TransactionsCount'}, 'abc')
  end

  def test_send
    Dwolla.stubs(:request).with(:post, '/transactions/send',
                                {
                                    :pin => 1337,
                                    :amount => 15.00,
                                    :destinationId => '812-111-1111'
                                }, {}, 'abc')

    # Send is also an alias but is not tested since it is redundant
    Dwolla::Transactions.create({
                                  :pin => 1337,
                                  :amount => 15.00,
                                  :destinationId => '812-111-1111'
                              }, 'abc')
  end

  def test_refund
    Dwolla.stubs(:request).with(:post, '/transactions/refund',
                                {
                                    :pin => 1337,
                                    :fundsSource => 'Balance',
                                    :transactionId => '123456',
                                    :amount => 15.00
                                }, {}, 'abc')
    Dwolla::Transactions.refund({
                                    :pin => 1337,
                                    :fundsSource => 'Balance',
                                    :transactionId => '123456',
                                    :amount => 15.00
                                }, 'abc')
  end

  def test_schedule
    Dwolla.stubs(:request).with(:post, '/transactions/scheduled',
                                {
                                    :pin => 1337,
                                    :amount => 15.00,
                                    :destinationId => '812-111-1111',
                                    :fundsSource => 'abcdef',
                                    :scheduleDate => '2015-10-19'
                                }, {}, 'abc')

    Dwolla::Transactions.schedule({
                                    :pin => 1337,
                                    :amount => 15.00,
                                    :destinationId => '812-111-1111',
                                    :fundsSource => 'abcdef',
                                    :scheduleDate => '2015-10-19'
                              }, 'abc')    
  end

  def test_scheduled
    Dwolla.stubs(:request).with(:get, '/transactions/scheduled',
                                {}, {}, 'abc')

    Dwolla::Transactions.scheduled({}, 'abc')    
  end

  def test_scheduled_by_id
    Dwolla.stubs(:request).with(:get, '/transactions/scheduled/1234',
                                {}, {}, 'abc')

    Dwolla::Transactions.scheduled_by_id('1234', 'abc')    
  end  

  def test_edit_scheduled
     Dwolla.stubs(:request).with(:post, '/transactions/scheduled/12345',
                                {
                                    :pin => 1337,
                                    :amount => 15.00,
                                }, {}, 'abc')

    Dwolla::Transactions.edit_scheduled('12345', {
                                    :pin => 1337,
                                    :amount => 15.00}, 'abc')      
  end

  def test_delete_scheduled_by_id
     Dwolla.stubs(:request).with(:delete, '/transactions/scheduled/12345',
                                {
                                    :pin => 1337,
                                }, {}, 'abc')

    Dwolla::Transactions.delete_scheduled_by_id('12345', {
                                    :pin => 1337}, 'abc')      
  end

  def test_delete_all_scheduled
     Dwolla.stubs(:request).with(:delete, '/transactions/scheduled',
                                {
                                    :pin => 1337,
                                }, {}, 'abc')

    Dwolla::Transactions.delete_all_scheduled({
                                    :pin => 1337}, 'abc')      
  end

end