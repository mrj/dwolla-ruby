require 'stringio'
require 'test/unit'
require 'dwolla'
require 'mocha/setup'
include Mocha

#monkeypatch request methods
module Dwolla
  @mock_rest_client = nil

  def self.mock_rest_client=(mock_client)
    @mock_rest_client = mock_client
  end

  def self.execute_request(opts)
    get_params = (opts[:headers] || {})[:params]
    post_params = opts[:payload]
    
    case opts[:method]
      when :get then @mock_rest_client.get opts[:url], get_params, post_params
      when :post then @mock_rest_client.post opts[:url], get_params, post_params
    end
  end
end

def test_response(body, code=200)
  # When an exception is raised, restclient clobbers method_missing.  Hence we
  # can't just use the stubs interface.
  body = MultiJson.dump(body) if !(body.kind_of? String)
  m = mock  
  m.instance_variable_set('@dwolla_values', { :body => body, :code => code })
  def m.body; @dwolla_values[:body]; end
  def m.code; @dwolla_values[:code]; end
  m
end

def test_transaction_byid(params={})
  {
    :Success => true,
    :Message => 'Success',
    :Response => {
      :Id => 2834469,
      :Amount => 1,
      :Date => "05/02/2013 17:18:09",
      :Type => "withdrawal",
      :UserType => "Dwolla",
      :DestinationId => "XXX80-1",
      :DestinationName => "Veridian Credit Union",
      :SourceId => "812-734-7288",
      :SourceName => "Michael Schonfeld",
      :ClearingDate => "5/2/2013",
      :Status => "processed",
      :Notes => nil,
      :Fees => nil
    }
  }.merge(params)
end

def test_transactions_array(params={})  
  {
    :Success => true,
    :Message => 'Success',
    :Response => [
      {
        :Id => 2834469,
        :Amount => 1,
        :Date => "05/02/2013 17:18:09",
        :Type => "withdrawal",
        :UserType => "Dwolla",
        :DestinationId => "XXX80-1",
        :DestinationName => "Veridian Credit Union",
        :SourceId => "812-734-7288",
        :SourceName => "Michael Schonfeld",
        :ClearingDate => "5/2/2013",
        :Status => "processed",
        :Notes => nil,
        :Fees => nil
      },
      {
        :Id => 2834457,
        :Amount => 1,
        :Date => "05/02/2013 17:17:02",
        :Type => "deposit",
        :UserType => "Dwolla",
        :DestinationId => "812-734-7288",
        :DestinationName => "Michael Schonfeld",
        :SourceId => "XXX80-1",
        :SourceName => "Veridian Credit Union",
        :ClearingDate => "5/2/2013",
        :Status => "processed",
        :Notes => nil,
        :Fees => nil
      }
    ]
  }.merge(params)
end

def test_transactions_stats(params={})  
  {
    :Success => true,
    :Message => 'Success',
    :Response => [
      {
        :TransactionsCount => 3,
        :TransactionsTotal => 0.03
      }
    ]
  }.merge(params)
end

def test_balance(params={})
  {
    :Success => true,
    :Message => 'Success',
    :Response => 10.00
  }.merge(params)
end

def test_send(params={})
  {
    :Success => true,
    :Message => 'Success',
    :Response => 2834853
  }.merge(params)
end

def test_request(params={})
  {
    :Success => true,
    :Message => 'Success',
    :Response => 2221134
  }.merge(params)
end

def test_request_byid(params={})
  {
    :Success => true,
    :Message => 'Success',
    :Response => {
      :Id => 2209516,
      :Source => {
        :Id => "812-734-7288",
        :Name => "Michael Schonfeld",
        :Type => "Dwolla",
        :Image => nil
      },
      :Destination => {
        :Id => "812-552-5325",
        :Name => "Mark Littlewood",
        :Type => "Dwolla",
        :Image => nil
      },
      :Amount => 8,
      :DateRequested => "8/15/2012 10:18:46 PM",
      :Status => "Pending",
      :Transaction => nil
    }
  }.merge(params)
end

def test_requests_array(params={})
  {
    :Success => true,
    :Message => 'Success',
    :Response => [
      {
        :Id => 2209516,
        :Source => {
          :Id => "812-734-7288",
          :Name => "Michael Schonfeld",
          :Type => "Dwolla",
          :Image => nil
        },
        :Destination => {
          :Id => "812-552-5325",
          :Name => "Mark Littlewood",
          :Type => "Dwolla",
          :Image => nil
        },
        :Amount => 8,
        :DateRequested => "8/15/2012 10:18:46 PM",
        :Status => "Pending",
        :Transaction => nil
      },
      {
        :Id => 2213417,
        :Source => {
          :Id => "812-713-9234",
          :Name => "Dwolla",
          :Type => "Dwolla",
          :Image => nil
        },
        :Destination => {
          :Id => "812-734-7288",
          :Name => "Michael Schonfeld",
          :Type => "Dwolla",
          :Image => nil
        },
        :Amount => 0.1,
        :DateRequested => "12/4/2012 5:20:38 PM",
        :Status => "Pending",
        :Transaction => nil
      }
    ]
  }.merge(params)
end

def test_request_cancel(params={})
  {
    :Success => true,
    :Message => 'Success',
    :Response => ''
  }.merge(params)
end

def test_request_fulfill(params={})
  {
    :Success => true,
    :Message => 'Success',
    :Response => {
      :Id => 2844131,
      :RequestId => 2219682,
      :Source => {
        :Id => "812-734-7288",
        :Name => "Michael Schonfeld",
        :Type => "Dwolla",
        :Image => nil
      },
      :Destination => {
        :Id => "812-726-8148",
        :Name => "Paul Liberman",
        :Type => "Dwolla",
        :Image => nil
      },
      :Amount => 1,
      :SentDate => "5/3/2013 10:55:56 AM",
      :ClearingDate => "5/3/2013 10:55:56 AM",
      :Status => "processed"
    }
  }.merge(params)
end

def test_fundingsource_byid(params={})
  {
    :Success => true,
    :Message => 'Success',
    :Response => {
      :Balance => 7.74,
      :Id => "a4946ae2d2b7f1f880790f31a36887f5",
      :Name => "Veridian Credit Union - Savings",
      :Type => "Savings",
      :Verified => true,
      :ProcessingType => "FiSync"
    }
  }.merge(params)
end

def test_fundingsources_array(params={})
  {
    :Success => true,
    :Message => 'Success',
    :Response => [
      {
        :Id => "a4946ae2d2b7f1f880790f31a36887f5",
        :Name => "Veridian Credit Union - Savings",
        :Type => "Savings",
        :Verified => true,
        :ProcessingType => "FiSync"
      },
      {
        :Id => "c21012f98742d4b0affcd8aeabefb369",
        :Name => "My Checking Account - Checking",
        :Type => "Checking",
        :Verified => true,
        :ProcessingType => "ACH"
      }
    ]
  }.merge(params)
end

def test_fundingsource_withdraw(params={})
  {
    :Success => true,
    :Message => 'Success',
    :Response => {
      :Id => 2834469,
      :Amount => 1,
      :Date => "5/2/2013 9:18:09 PM",
      :Type => "withdrawal",
      :UserType => "Dwolla",
      :DestinationId => "XXX80-1",
      :DestinationName => "Veridian Credit Union",
      :SourceId => "812-734-7288",
      :SourceName => "Michael Schonfeld",
      :ClearingDate => "5/2/2013",
      :Status => "pending",
      :Notes => nil,
      :Fees => nil
    }
  }.merge(params)
end

def test_fundingsource_deposit(params={})
  {
    :Success => true,
    :Message => 'Success',
    :Response => {
      :Id => 2834457,
      :Amount => 1,
      :Date => "5/2/2013 9:17:02 PM",
      :Type => "deposit",
      :UserType => "Dwolla",
      :DestinationId => "812-734-7288",
      :DestinationName => "Michael Schonfeld",
      :SourceId => "XXX80-1",
      :SourceName => "Veridian Credit Union",
      :ClearingDate => "5/2/2013",
      :Status => "pending",
      :Notes => nil,
      :Fees => nil
    }
  }.merge(params)
end

def test_user_self(params={})
  {
    :Success => true,
    :Message => 'Success',
    :Response => {
      :City => "Paris",
      :State => "TN",
      :Type => "Personal",
      :Id => "812-629-2658",
      :Name => "Codeacademy Course",
      :Latitude => 0,
      :Longitude => 0
    }
  }.merge(params)
end

def test_user_byid(params={})
  {
    :Success => true,
    :Message => 'Success',
    :Response => {
      :Name => "Alex Hart",
      :Id => "812-499-5823",
      :Type => "Dwolla",
      :Image => "https://www.dwolla.com/avatars/812-499-5823",
      :City => nil,
      :State => nil
    }
  }.merge(params)
end

def test_users_array(params={})
  {
    :Success => true,
    :Message => 'Success',
    :Response => [
      {
        :Name => "Alex Hart",
        :Id => "812-499-5823",
        :Type => "Dwolla",
        :Image => "https://www.dwolla.com/avatars/812-499-5823",
        :City => nil,
        :State => nil
      },
      {
        :Name => "Alexander Taub",
        :Id => "812-626-8794",
        :Type => "Dwolla",
        :Image => "https://www.dwolla.com/avatars/812-626-8794",
        :City => nil,
        :State => nil
      }
    ]
  }.merge(params)
end

def test_contacts_array(params={})
  {
    :Success => true,
    :Message => 'Success',
    :Response => [
      {
        :Name => "Pinnacle Marketing",
        :Id => "812-464-9495",
        :Type => "Dwolla",
        :Image => "https://www.dwolla.com/avatars/812-464-9495",
        :Latitude => 0,
        :Longitude => 0,
        :Address => "Box 311\n134 Moore Hill Road",
        :City => "Newbury",
        :State => "VT",
        :PostalCode => "05051",
        :Group => "812-534-7970,812-530-2592,812-451-7983,812-554-6122,812-499-3232,812-475-9151,812-568-7828,812-518-8055,812-514-9530",
        :Delta => 0
      },
      {
        :Name => "CMS Plus Hosting LLC",
        :Id => "812-534-7970",
        :Type => "Dwolla",
        :Image => "https://www.dwolla.com/avatars/812-534-7970",
        :Latitude => 0,
        :Longitude => 0,
        :Address => "20 E BEECH\nPO BOX 47",
        :City => "Cedar Springs",
        :State => "MI",
        :PostalCode => "49319",
        :Group => "812-464-9495,812-530-2592,812-451-7983,812-554-6122,812-499-3232,812-475-9151,812-568-7828,812-518-8055,812-514-9530",
        :Delta => 0
      }
    ]
  }.merge(params)
end

def test_api_error
  {
    :Success => false,
    :Message => 'Success',
    :Response => ''
  }
end