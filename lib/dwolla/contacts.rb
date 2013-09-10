module Dwolla
    class Contacts
        def self.get(filters={}, token=nil)
            url = contacts_url

            Dwolla.request(:get, url, filters, {}, token)
        end


        def self.nearby(filters={})
            url = contacts_url + 'nearby'

            Dwolla.request(:get, url, filters, {}, false)
        end

        private

        def self.contacts_url
            return '/contacts/'
        end
    end
end
