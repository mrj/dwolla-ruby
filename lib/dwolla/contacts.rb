module Dwolla
    class Contacts
        def self.get(filters={}, token=nil)
            url = contacts_url

            Dwolla.request(:get, url, filters, {}, token)
        end


        def self.nearby(lat=nil, lon=nil, filters={})
          raise MissingParameterError.new('No Latitude Provided') unless lat
          raise MissingParameterError.new('No Longitude Provided.') unless lon

          url = contacts_url + 'nearby'

          params = {
              :latitude => lat,
              :longitude => lon
          }.merge(filters)

          Dwolla.request(:get, url, params, {}, false)
        end

        private

        def self.contacts_url
            return '/contacts/'
        end
    end
end
