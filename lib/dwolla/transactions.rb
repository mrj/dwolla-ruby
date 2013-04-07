module Dwolla
    class Transactions
        def self.get(id=nil, filters={})
            url = transactions_url

            if id.is_a?(Hash)
                filters = id
                id = nil
            else
                filters = {}
            end

            url += id.to_s unless id.nil?

            Dwolla.request(:get, url, filters)
        end

        def self.stats(filters={})
            url = transactions_url + 'stats'

            Dwolla.request(:get, url, filters)
        end

        def self.create(params={})
            url = transactions_url + 'send'

            resp = Dwolla.request(:post, url, params)

            puts resp
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
