require 'test/unit'
require 'mocha/test_unit'
require 'dwolla'

class ContactsTest < Test::Unit::TestCase
  def test_get
    Dwolla.stubs(:request).with(:get, '/contacts/', { :search => 'Test Parameter' }, {}, 'abc')
    Dwolla::Contacts.get({:search => 'Test Parameter'}, 'abc')
  end

  def test_nearby
    Dwolla.stubs(:request).with(:get, '/contacts/nearby',
                                {
                                    :latitude => 35,
                                    :longitude => 45,
                                    :limit => 10
                                }, {}, false)
    Dwolla::Contacts.nearby(35, 45, { :limit => 10 })
  end
end