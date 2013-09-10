module Dwolla
    class Requests
        def self.get(id=nil, filters={}, token=nil)
            url = requests_url

            if id.is_a?(Hash)
                filters = id
                id = nil
            else
                filters = {}
            end

            url += id.to_s unless id.nil?

            Dwolla.request(:get, url, filters, {}, token)
        end

        def self.delete(id=nil, token=nil)
            raise MissingParameterError.new('No Request ID Provided.') if id.nil?

            url = requests_url + id.to_s + '/cancel'

            Dwolla.request(:post, url, {}, {}, token)
        end

        def self.create(params={}, token=nil)
            raise MissingParameterError.new('No Source ID Provided.') unless params[:sourceId]
            raise MissingParameterError.new('No Amount Provided.') unless params[:amount]

            url = requests_url

            Dwolla.request(:post, url, params, {}, token)
        end

        def self.fulfill(id=nil, params={}, token=nil)
            raise MissingParameterError.new('No Request ID Provided.') if id.nil?
            raise MissingParameterError.new('No PIN Provided.') unless params[:pin]

            url = requests_url + id.to_s + '/fulfill'

            Dwolla.request(:post, url, params, {}, token)
        end

        class << self
            alias_method :pending, :get
            alias_method :cancel, :delete
            alias_method :request, :create
        end

        private

        def self.requests_url
            return '/requests/'
        end
    end
end
