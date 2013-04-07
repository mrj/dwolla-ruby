module Dwolla
    class Users
        def self.get(id=nil)
            url = users_url

            unless id.nil?
                url += id.to_s
                @oauth = false
            else
                @oauth = true
            end

            Dwolla.request(:get, url, {}, {}, @oauth)
        end

        def self.me
            # I'm not using the 'alias_method' fn
            # because the .me method should not
            # honor any parameters (i.e. User IDs)
            # passed to it
            self.get
        end

        def self.nearby(filters={})
            url = users_url + 'nearby'

            Dwolla.request(:get, url, filters, {}, false)
        end

        private

        def self.users_url
            return '/users/'
        end
    end
end
