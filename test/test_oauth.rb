require 'test/unit'
require 'mocha/test_unit'
require 'dwolla'

class OAuthTest < Test::Unit::TestCase
  def test_get_auth_url
    Dwolla::api_key = 'abcd'
    Dwolla::scope = 'efgh'
    assert Dwolla::OAuth.get_auth_url == "https://www.dwolla.com/oauth/v2/authenticate?client_id=abcd&response_type=code&scope=efgh"
  end

  def test_get_token
end