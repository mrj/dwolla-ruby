module Dwolla
    class Register
        def self.step(token=nil)
            url = register_url + 'step'

            Dwolla.request(:get, url, {}, {}, token)
        end

        def self.create(token=nil)

        end

        def self.resend_email(token=nil)

        end

        def self.verify_email(token=nil)

        end

        def self.add_phone(token=nil)

        end

        def self.resend_phone(token=nil)

        end

        def self.verify_phone(token=nil)

        end

        def self.set_address(token=nil)

        end

        def self.get_kba(token=nil)

        end

        def self.answer_kba(token=nil)

        end

        def self.set_general_info(token=nil)

        end

        private

        def self.register_url
            return '/register/'
        end
    end
end
