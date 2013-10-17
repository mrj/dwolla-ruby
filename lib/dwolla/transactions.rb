module Dwolla
    class Transactions
        def self.get(id=nil, filters={}, token=nil)
            url = transactions_url

            if id.is_a?(Hash)
                filters = id
                id = nil
            else
                filters = {}
            end

            url += id.to_s unless id.nil?

            Dwolla.request(:get, url, filters, {}, token)
        end

        def self.stats(filters={}, token=nil)
            url = transactions_url + 'stats'

            Dwolla.request(:get, url, filters, {}, token)
        end

        def self.create(params={}, token=nil)
            raise MissingParameterError.new('No PIN Provided.') unless params[:pin]
            raise MissingParameterError.new('No Destination ID Provided.') unless params[:destinationId]
            raise MissingParameterError.new('No Amount Provided.') unless params[:amount]

            url = transactions_url + 'send'

            Dwolla.request(:post, url, params, {}, token)
        end

        def self.refund(params={}, token=nil)
            raise MissingParameterError.new('No PIN Provided.') unless params[:pin]
            raise MissingParameterError.new('No Funding Source Provided.') unless params[:fundsSource]
            raise MissingParameterError.new('No Transaction ID Provided.') unless params[:transactionId]
            raise MissingParameterError.new('No Amount Provided.') unless params[:amount]

            url = transactions_url + 'refund'

            Dwolla.request(:post, url, params, {}, token)
        end

        def self.guest_send(params={})
            raise MissingParameterError.new('No Destination ID Provided.') unless params[:destinationId]
            raise MissingParameterError.new('No Amount Provided.') unless params[:amount]
            raise MissingParameterError.new('No First Name Provided.') unless params[:firstName]
            raise MissingParameterError.new('No Last Name Provided.') unless params[:lastName]
            raise MissingParameterError.new('No Email Address Provided.') unless params[:emailAddress]
            raise MissingParameterError.new('No Routing Number (ABA) Provided.') unless params[:routingNumber]
            raise MissingParameterError.new('No Account Number Provided.') unless params[:accountNumber]
            raise MissingParameterError.new('No Account Type Provided.') unless params[:accountType]

            url = transactions_url + 'guestsend'

            Dwolla.request(:post, url, params, {}, false)
        end

        class << self
            alias_method :listing, :get
            alias_method :send, :create
        end

        private

        def self.transactions_url
            return '/transactions/'
        end
    end
end
