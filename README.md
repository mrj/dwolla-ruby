# dwolla-ruby

[![Join the chat at https://gitter.im/Dwolla/dwolla-ruby](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/Dwolla/dwolla-ruby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
Official Ruby wrapper for Dwolla's API

## Version
2.6.5

[![Build Status](https://travis-ci.org/Dwolla/dwolla-ruby.svg?branch=master)](https://travis-ci.org/Dwolla/dwolla-ruby)

## Requirements
- [Ruby](http://www.ruby-lang.org/)

## Installation
The easiest way to install the dwolla-ruby gem for now is to use bundler and add the following line to your Gemfile:

   `gem 'dwolla-ruby'`

The recommended way to install dwolla-ruby is through RubyGems:

   `gem install dwolla-ruby`

## Examples / Quickstart

To use the examples in the /examples folder, first edit the _keys.rb file and add your Dwolla API application's key, and secret, along with your account's [OAuth token](https://developers.dwolla.com/dev/token), and PIN.

This repo includes various usage examples, including:

* Authenticating with OAuth [oauth.rb]
* Fetching user information [users.rb]
* Grabbing a user's contacts [contacts.rb]
* Listing a user's funding sources [fundingSources.rb]
* Transacting money (includes sending) [transactions.rb]
* Getting a user's balance [balance.rb]

## Concurrent requests

If making requests using any background processing library such as `Sidkiq` or `Resque`, we recommend that you manually pass in tokens to functions which take an OAuth token. 

For example, we can do this with the `Contacts` class:

```ruby
# Include the Dwolla gem
require 'rubygems'
require 'pp'
require 'dwolla'

Dwolla::Contacts.get(nil, "your_token")
```

## Changelog

2.6.5
* Added new catalog endpoint to OAuth module + unit tests and examples.

2.6.4
* Fixed bug with refresh token call.  Parameters were not being JSON encoded.  Now OAuth `get_token` and `refresh_auth` calls use POST instead of GET.  

2.6.3
* Fixed webhook validation, cleaned up OpenSSL Digest calls (thanks, @michaelblinn)!

2.6.2
* Fixed bug with generation of Off-Site Gateway checkout URLs

2.6.1
* Minor refactoring, fixed bug that would cause crashes in certain Ruby version with checking if keys exist in hashes.

2.6.0

* **BREAKING CHANGE**: OAuth access tokens now expire. Instead of a string, `Dwolla::OAuth::get_token` now returns a hash with an `access_token`, `refresh_token`, and expiration times in seconds for both. In order to refresh authorization, use `Dwolla::OAuth.refresh_auth`
* **BREAKING CHANGE**: Guest send has been officially deprecated and removed from this gem. 
* All MassPay endpoints have been included in this release for batch payment support.
* Proper unit tests implemented for all endpoints.

2.5.5

* Pulled in a merge request for syntax error (thanks, @mstahl)

2.5.4

* Fixed offsite gateway URL (www.uat.dwolla.com is invalid whereas uat.dwolla.com is not).

2.5.3

* Updated offsite gateway to support UAT URL return when sandbox flag is toggled. 

2.5.2

* Sandbox base URL is now HTTPS

2.5.1

* Add the 'additionalFundingSources' param to the offsite gateway

2.5.0

* Add refund API endpoint

2.4.7 [merge pull request by [dustMason0](https://github.com/dustMason)]

* Remove debugging reference to 'pp' (thanks, dustMason)

2.4.6

* Fix method double naming in the OffsiteGateway class

2.4.5 [merge pull request by [dustMason0](https://github.com/dustMason)]

* Fix floating point calculation errors
* Refactor the offsite gateway class

2.4.4

* Globalize the OAuth scope variable

2.4.3

* Add missing files [accounts.rb]

2.4.2

* Fix OAuth token override

2.4.1

* Show raw response on debug mode
* Add support for 'Accounts' API
* Raise APIError when OAuth's get_token fails

2.4.0

* Added support for inline passage of OAuth tokens

2.3.0

* Add support for "sandbox" / UAT mode

2.1.1

* Oops. POST request wasn't actually sending any params.

2.1.0

* Add tests! (OMG WOOT JK </LOL>)

2.0.0

* Reworked Gem.

## Testing

To run the gem's tests:

	bundle exec rake test

## Credits

This wrapper is heavily based off Stripe's Ruby Gem

- Michael Schonfeld &lt;michael@dwolla.com&gt;

## Support

We highly recommend seeking support on our forums, [located here!](https://discuss.dwolla.com/category/api-support)

- Dwolla API &lt;api@dwolla.com&gt;
- David Stancu &lt;david@dwolla.com&gt;
- Gordon Zheng &lt;gordon@dwolla.com&gt;

## References / Documentation

http://developers.dwolla.com/dev

## License

(The MIT License)

Copyright (c) 2013 Dwolla &lt;michael@dwolla.com&gt;

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
