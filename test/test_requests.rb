require 'test/unit'
require 'mocha/test_unit'
require 'dwolla'

class RequestsTest < Test::Unit::TestCase
  def test_get
    Dwolla.stubs(:request).with(:get, '/requests/', {:limit => 10}, {}, 'abc')
    Dwolla::Requests.get({:limit => 10}, {}, 'abc')
  end

  def test_get_by_id
    Dwolla.stubs(:request).with(:get, '/requests/123456', {}, {}, 'abc')
    Dwolla::Requests.get('123456', {}, 'abc')
  end

  def test_create
    Dwolla.stubs(:request).with(:post, '/requests/', {:sourceId => '812-111-1234', :amount => 5.00}, {}, 'abc')
    Dwolla::Requests.create({:sourceId => '812-111-1234', :amount => 5.00}, 'abc')
  end

  def test_delete
    Dwolla.stubs(:request).with(:post, '/requests/123456/cancel', {}, {}, 'abc')
    Dwolla::Requests.delete('123456', 'abc')
  end

  def test_fulfill
    Dwolla.stubs(:request).with(:post, '/requests/123456/fulfill', {:pin => 1337}, {}, 'abc')
    Dwolla::Requests.fulfill('123456', {:pin => 1337}, 'abc')
  end
end