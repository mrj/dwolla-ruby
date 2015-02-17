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
    Dwolla.stubs(:request).with(:post, 'https://www.dwolla.com/oauth/v2/token',
                                {
                                    :grant_type => 'authorization_code',
                                    :code => 'abc',
                                    :redirect_uri => 'http://google.com'
                                }, {}, false, false, true)
    Dwolla::OAuth.get_token('abc', 'http://google.com')
  end

  def test_refresh_auth
    Dwolla.stubs(:request).with(:post, 'https://www.dwolla.com/oauth/v2/token',
                                {
                                    :grant_type => 'refresh_token',
                                    :refresh_token => 'abc'
                                }, {}, false, false, true)
    Dwolla::OAuth.refresh_auth('abc')
  end

end