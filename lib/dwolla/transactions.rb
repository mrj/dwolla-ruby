module Dwolla
    class Transactions

        def get(params={})
            response, api_key = Dwolla.request(:get, transactions_url, @token, params)
            self
        end

        private
            def transactions_url
                url + '/transactions'
            end
        end
    end
end
