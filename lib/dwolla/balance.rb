module Dwolla
    class Balance
        def self.get(token=nil)
            url = balance_url

            Dwolla.request(:get, url, {}, {}, token)
        end

        private

        def self.balance_url
            return '/balance/'
        end
    end
end
