module Dwolla
    class OffsiteGateway
        @products = []
        @discount = 0
        @tax = 0
        @shipping = 0

        def self.clear_session
            @products = []
        end

        def self.add_product(name=nil, description=nil, price=nil, qty=1)
            @products.push {
                :name => name,
                :description => description,
                :price => price,
                :qty => qty
            }
        end

        def self.discount=(discount)
            @discount = discount
        end

        def self.tax=(tax)
            @tax = tax
        end

        def self.shipping=(shipping)
            @shipping = shipping
        end

        def self.get_checkout_url(destinationId=nil, allowFundingSources=false)
            params = {
                
            }

            return request_url
        end

        private

        def self.request_url
            return 'https://www.dwolla.com/payment/request'
        end

        def self.calculate_total

        end

    end
end
