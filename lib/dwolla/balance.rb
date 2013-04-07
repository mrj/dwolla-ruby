module Dwolla
    class Balance
        def self.get
            url = balance_url

            Dwolla.request(:get, url)
        end

        private

        def self.balance_url
            return '/balance/'
        end
    end
end
