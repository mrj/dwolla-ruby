require 'test/unit'
require 'mocha/test_unit'
require 'dwolla'

class MassPayTest < Test::Unit::TestCase
  def test_get
    Dwolla.stubs(:request).with(:get, '/masspay/', {}, {}, 'abc')
    Dwolla::MassPay.get('abc')
  end

  def test_create
    Dwolla.stubs(:request).with(:post, '/masspay/',
                                {
                                    :fundsSource => 'Balance',
                                    :pin => 1337,
                                    :items =>
                                        {
                                            :amount => 13.37,
                                            :destination => '812-111-1234'
                                        }
                                }, {}, 'abc')
    Dwolla::MassPay.create(
        {
            :fundsSource => 'Balance',
            :pin => 1337,
            :items =>
                {
                    :amount => 13.37,
                    :destination => '812-111-1234'
                }
        }, 'abc')
  end

  def test_getItems
    Dwolla.stubs(:request).with(:get, '/masspay/123456/items', { :limit => 10 }, {}, 'abc')
    Dwolla::MassPay.getItems('123456', { :limit => 10 }, 'abc')
  end

  def test_getItem
    Dwolla.stubs(:request).with(:get, '/masspay/123456/items/654321', {}, {}, 'abc')
    Dwolla::MassPay.getItem('123456', '654321', 'abc')
  end

  def test_getJob
    Dwolla.stubs(:request).with(:get, '/masspay/123456', {}, {}, 'abc')
    Dwolla::MassPay.getJob('123456', 'abc')
  end
end