module Dwolla
    class OffsiteGateway
        @products = []
        @discount = 0
        @tax = 0
        @shipping = 0
        @destination_id = nil
        @notes = nil
        @facilitatorAmount = nil

        def self.clear_session
            @products = []
        end

        def self.add_product(name=nil, description=nil, price=nil, quantity=1)
            @products.push {
                :name => name,
                :description => description,
                :price => price,
                :quantity => quantity
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

        def self.get_checkout_url(params={})
            params = {
                :key => Dwolla::api_key,
                :secret => Dwolla::api_secret,
                :purchaseOrder => {
                    :destinationId => @destinationId,
                    :orderItems => @products,
                    :discount => @discount,
                    :shipping => @shipping,
                    :tax => @tax,
                    :total => @total
                }
            }

            resp = Dwolla.request(:post, request_url, params, {}, false, false)

            return checkout_url + resp['CheckoutId']
        end

        private

        def self.request_url
            return 'https://www.dwolla.com/payment/request'
        end

        def self.checkout_url
            return 'https://www.dwolla.com/payment/checkout/'
        end

        def self.calculate_total
            @total = 0

            @products.each { |product|
                @total += product['price'] * product['quantity']
            }

            return @total
        end

    end
end
