require 'test/unit'
require 'mocha/test_unit'
require 'dwolla'

class UsersTest < Test::Unit::TestCase
  def test_get_oauth
    Dwolla.stubs(:request).with(:get, '/users/', {}, {}, 'abc')
    Dwolla::Users.get(nil, 'abc')
  end

  def test_get_id
    Dwolla.stubs(:request).with(:get, '/users/812-111-1111', {}, {}, false)
    Dwolla::Users.get('812-111-1111')
  end

  # This test is redundant, however it is a different function and therefore
  # I'm going to test it anyway.
  def test_me
    Dwolla.stubs(:request).with(:get, '/users/', {}, {}, 'abc')
    Dwolla::Users.me('abc')
  end

  def test_nearby
    Dwolla.stubs(:request).with(:get, '/users/nearby',
                                {
                                    :latitude => 45,
                                    :longitude => 50
                                }, {}, false)
    Dwolla::Users.nearby({
                             :latitude => 45,
                             :longitude => 50
                         })
  end
end