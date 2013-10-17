# dwolla-ruby
Official Ruby wrapper for Dwolla's API

## Version
2.5.0

## Requirements
- [Ruby](http://www.ruby-lang.org/)

## Installation
The easiest way to install the dwolla-ruby gem for now is to use bundler and add the following line to your Gemfile:

  gem 'dwolla-ruby'

The recommended way to install dwolla-ruby is through RubyGems:

  gem install dwolla-ruby

## Examples / Quickstart

To use the examples in the /examples folder, first edit the _keys.rb file and add your Dwolla API application's key, and secret, along with your account's [OAuth token](https://developers.dwolla.com/dev/token), and PIN.

This repo includes various usage examples, including:

* Authenticating with OAuth [oauth.rb]
* Sending money [send.rb]
* Fetching user information [users.rb]
* Grabbing a user's contacts [contacts.rb]
* Listing a user's funding sources [fundingSources.rb]
* Transacting money [transactions.rb]
* Getting a user's balance [balance.rb]

## Changelog

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

- Dwolla API &lt;api@dwolla.com&gt;
- Michael Schonfeld &lt;michael@dwolla.com&gt;

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
