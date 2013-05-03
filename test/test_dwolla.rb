# -*- coding: utf-8 -*-
require File.expand_path('../test_helper', __FILE__)
require 'test/unit'
require 'shoulda'
require 'mocha/setup'
require 'pp'
require 'rest-client'
require 'cgi'
require 'uri'

class TestDwollaRuby < Test::Unit::TestCase
  include Mocha

  context "API Wrapper" do
    setup do
      @mock = mock
      Dwolla.mock_rest_client = @mock
    end

    teardown do
      Dwolla.mock_rest_client = nil
    end

    should "not specifying a token should raise an exception on user-centric calls" do
      Dwolla.token = nil
      assert_raises Dwolla::AuthenticationError do
        Dwolla::Balance.get
      end
    end

    should "not specifying api credentials should raise an exception on app-centric calls" do
      Dwolla.api_key = nil
      assert_raises Dwolla::AuthenticationError do
        Dwolla::Contacts.nearby
      end
    end

    context "with valid token" do
      setup do
        Dwolla.token="foo"
      end

      teardown do
        Dwolla.token=nil
      end

      context "balance tests" do 
        should "balance should be retrievable" do
          @mock.expects(:get).once.returns(test_response(test_balance))
          balance = Dwolla::Balance.get
          assert balance.kind_of? Float
        end
      end

      context "contacts tests" do
        should "be able to get a user's contacts" do
          @mock.expects(:get).once.returns(test_response(test_contacts_array))
          contacts = Dwolla::Contacts.get
          assert contacts.kind_of? Array
        end
      end

      context "funding sources tests" do
        should "should be able to get a user's funding source by its id" do
          @mock.expects(:get).once.returns(test_response(test_fundingsource_byid))
          fundingsource = Dwolla::FundingSources.get('funding_source_id')
          assert fundingsource.kind_of? Object
        end

        should "should be able to get a user's funding sources" do
          @mock.expects(:get).once.returns(test_response(test_fundingsources_array))
          fundingsources = Dwolla::FundingSources.get
          assert fundingsources.kind_of? Array
        end

        should "should be able to withdraw to a user's funding source" do
          @mock.expects(:post).once.returns(test_response(test_fundingsource_withdraw))
          withdraw = Dwolla::FundingSources.withdraw('funding_source_id', {:pin => '0000', :amount => '1.00'})
          assert withdraw.kind_of? Object
        end

        should "should be able to deposit from a user's funding source" do
          @mock.expects(:post).once.returns(test_response(test_fundingsource_deposit))
          withdraw = Dwolla::FundingSources.withdraw('funding_source_id', {:pin => '0000', :amount => '1.00'})
          assert withdraw.kind_of? Object
        end

        should "should be able to add a funding source for a user" do

        end

        should "should be able to verify a user's funding source" do

        end
      end

      context "requests tests" do
        should "should be able to get a user's pending money requests" do
          @mock.expects(:get).once.returns(test_response(test_requests_array))
          requests = Dwolla::Requests.get
          assert requests.kind_of? Array
        end

        should "should be able to get a user's pending money request by its id" do
          @mock.expects(:get).once.returns(test_response(test_request_byid))
          request = Dwolla::Requests.get('request_id')
          assert request.kind_of? Object
        end

        should "should be able to cancel a user's pending money request" do
          @mock.expects(:post).once.returns(test_response(test_request_cancel))
          request = Dwolla::Requests.cancel('request_id')
          assert request.kind_of? String
        end

        should "should be able to create a new money request for a user" do
          @mock.expects(:post).once.returns(test_response(test_request))
          request = Dwolla::Requests.request({:pin => 1111, :amount => 0.01, :sourceId => 'alex@dwolla.com'})
          assert request.kind_of? Integer
        end

        should "should be a able to fulfill a user's pending money request" do
          @mock.expects(:post).once.returns(test_response(test_request_fulfill))
          request = Dwolla::Requests.fulfill('2219682', {:pin => 1111})
          assert request.kind_of? Object
        end
      end

      context "transactions tests" do
        should "should be able to get a user's transaction information by its id" do
          @mock.expects(:get).once.returns(test_response(test_transaction_byid))
          transactions = Dwolla::Transactions.get('transaction_id')
          assert transactions.kind_of? Object
        end

        should "should be able to get a user's transaction history" do
          @mock.expects(:get).once.returns(test_response(test_transactions_array))
          transactions = Dwolla::Transactions.get
          assert transactions.kind_of? Array
        end

        should "should be able to get a user's transaction statistics" do
          @mock.expects(:get).once.returns(test_response(test_transactions_stats))
          stats = Dwolla::Transactions.stats
          assert stats.kind_of? Object
        end

        should "should be able to send money from a user's account" do
          @mock.expects(:post).once.returns(test_response(test_send))
          send = Dwolla::Transactions.send({:pin => 1111, :destinationId => '812-734-7288', :amount => 0.01})
          assert send.kind_of? Integer
        end
      end

      context "users tests" do
        should "should be able to get a user's information" do
          @mock.expects(:get).once.returns(test_response(test_user_self))
          user = Dwolla::Users.me
          assert user.kind_of? Object
        end
      end
    end

    context "with valid app credentials" do
      setup do
        Dwolla.api_key="foo"
        Dwolla.api_secret="bar"
      end

      teardown do
        Dwolla.api_key=nil
        Dwolla.api_secret=nil
      end

      context "contacts tests" do
        should "be able to get a list of nearby spots" do
          @mock.expects(:get).once.returns(test_response(test_contacts_array))
          spots = Dwolla::Contacts.nearby
          assert spots.kind_of? Array
        end
      end

      context "users tests" do
        should "should be able to get any user's information" do
          @mock.expects(:get).once.returns(test_response(test_user_byid))
          user = Dwolla::Users.get('alex@dwolla.com')
          assert user.kind_of? Object
        end

        should "should be able to get a list of nearby users" do
          @mock.expects(:get).once.returns(test_response(test_users_array))
          users = Dwolla::Users.nearby
          assert users.kind_of? Array
        end
      end
    end
  end
end