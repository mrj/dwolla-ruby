module Dwolla
    class OffsiteGateway
        @products = []
        @discount = 0
        @tax = 0
        @shipping = 0
        @notes = nil
        @facilitatorAmount = nil
        @testMode = false
        @allowFundingSources = true
        @orderId = nil

        def self.clear_session
            @products = []
            @discount = 0
            @tax = 0
            @shipping = 0
            @notes = nil
            @facilitatorAmount = nil
            @testMode = false
            @allowFundingSources = true
            @orderId = nil
        end

        def self.add_product(name=nil, description=nil, price=nil, quantity=1)
            @products.push({
                :name => name,
                :description => description,
                :price => price,
                :quantity => quantity
            })
        end

        def self.set_customer_info(first_name=nil, last_name=nil, email=nil, city=nil, state=nil, zip=nil)
            @customerInfo = {
                :firstName => first_name,
                :lastName => last_name,
                :email => email,
                :city => city,
                :state => state,
                :zip => zip
            }
        end

        def self.discount=(discount)
            @discount = -(discount.abs)
        end

        def self.tax=(tax)
            @tax = tax
        end

        def self.shipping=(shipping)
            @shipping = shipping
        end

        def self.notes=(notes)
            @notes = notes
        end

        def self.order_id=(order_id)
            @orderId = order_id
        end

        def self.redirect=(redirect)
            @redirect = redirect
        end

        def self.callback=(callback)
            @callback = callback
        end

        def self.test=(test)
            @testMode = test
        end

        def self.get_checkout_url(destinationId)
            params = {
                :key => Dwolla::api_key,
                :secret => Dwolla::api_secret,
                :allowFundingSources => @allowFundingSources,
                :test => @testMode,
                :callback => @callback,
                :redirect => @redirect,
                :orderId => @orderId,
                :purchaseOrder => {
                    :customerInfo => @customerInfo,
                    :destinationId => destinationId,
                    :orderItems => @products,
                    :discount => @discount,
                    :shipping => @shipping,
                    :tax => @tax,
                    :total => self.calculate_total
                }
            }

            resp = Dwolla.request(:post, request_url, params, {}, false, false, true)
            raise APIError.new(resp['Message']) unless resp['Result'] == 'Success'

            return checkout_url + resp['CheckoutId']
        end

        def self.read_callback(body)
            data = JSON.load(body)

            verify_callback_signature(data['Signature'], data['CheckoutId'], data['Amount'])

            return data
        end

        def self.verify_webhook_signature(body, signature)
            verify_webhook_signature(signature, body)
        end

        private

        def self.verify_callback_signature(candidate=nil, checkout_id=nil, amount=nil)
            key = "#{checkout_id}&#{amount}"
            digest  = OpenSSL::Digest::Digest.new('sha1')
            signature = OpenSSL::HMAC.hexdigest(digest, Dwolla::api_secret, key)

            raise APIError.new("Invalid callback signature (#{candidate} vs #{signature})") unless candidate == signature
        end

        def self.verify_webhook_signature(candidate=nil, body=nil)
            digest  = OpenSSL::Digest::Digest.new('sha1')
            signature = OpenSSL::HMAC.hexdigest(digest, Dwolla::api_secret, body)

            raise APIError.new("Invalid Webhook signature (#{candidate} vs #{signature})") unless candidate == signature
        end

        def self.request_url
            return 'https://www.dwolla.com/payment/request'
        end

        def self.checkout_url
            return 'https://www.dwolla.com/payment/checkout/'
        end

        def self.calculate_total
            total = 0.0

            @products.each { |product|
                total += product[:price] * product[:quantity]
            }

            total += @shipping
            total += @tax
            total += @discount

            return total.round(2)
        end
    end
end
