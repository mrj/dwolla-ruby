module Dwolla
    class Transactions
        def self.get(id=nil, filters={}, token=nil)
            url = transactions_url

            if id.is_a?(Hash)
                filters = id
                id = nil
            else
                filters = {}
            end

            url += id.to_s unless id.nil?

            Dwolla.request(:get, url, filters, {}, token)
        end

        def self.stats(filters={}, token=nil)
            url = transactions_url + 'stats'

            Dwolla.request(:get, url, filters, {}, token)
        end

        def self.create(params={}, token=nil)
            raise MissingParameterError.new('No PIN Provided.') unless params[:pin]
            raise MissingParameterError.new('No Destination ID Provided.') unless params[:destinationId]
            raise MissingParameterError.new('No Amount Provided.') unless params[:amount]

            url = transactions_url + 'send'

            Dwolla.request(:post, url, params, {}, token)
        end

        def self.refund(params={}, token=nil)
            raise MissingParameterError.new('No PIN Provided.') unless params[:pin]
            raise MissingParameterError.new('No Funding Source Provided.') unless params[:fundsSource]
            raise MissingParameterError.new('No Transaction ID Provided.') unless params[:transactionId]
            raise MissingParameterError.new('No Amount Provided.') unless params[:amount]

            url = transactions_url + 'refund'

            Dwolla.request(:post, url, params, {}, token)
        end

        def self.schedule(params={}, token=nil)
            raise MissingParameterError.new('No PIN Provided.') unless params[:pin]
            raise MissingParameterError.new('No Destination ID Provided.') unless params[:destinationId]
            raise MissingParameterError.new('No Amount Provided.') unless params[:amount]
            raise MissingParameterError.new('No Scheduled Date Provided') unless params[:scheduleDate]
            raise MissingParameterError.new('No Funds Source Provided.') unless params[:fundsSource]

            url = transactions_url + 'scheduled'

            Dwolla.request(:post, url, params, {}, token)
        end

        def self.scheduled(filters={}, token=nil)
            url = transactions_url + 'scheduled'

            Dwolla.request(:get, url, filters, {}, token)
        end

        def self.scheduled_by_id(id, token=nil)
            raise MissingParameterError.new('No Scheduled Transaction ID Provided.') unless id

            url = transactions_url + 'scheduled/' 
            url += id.to_s unless id.nil?

            Dwolla.request(:get, url, {}, {}, token)
        end

        def self.edit_scheduled(id, params={}, token=nil)
            raise MissingParameterError.new('No PIN Provided.') unless params[:pin]
            raise MissingParameterError.new('No Scheduled Transaction ID Provided.') unless id

            url = transactions_url + 'scheduled/' 
            url += id.to_s unless id.nil?

            Dwolla.request(:post, url, params, {}, token)
        end

        def self.delete_scheduled_by_id(id, params={}, token=nil)
            raise MissingParameterError.new('No PIN Provided.') unless params[:pin]
            raise MissingParameterError.new('No Scheduled Transaction ID Provided.') unless id

            url = transactions_url + 'scheduled/'
            url += id.to_s unless id.nil?

            Dwolla.request(:delete, url, params, {}, token)
        end        

        def self.delete_all_scheduled(params={}, token=nil)
            raise MissingParameterError.new('No PIN Provided.') unless params[:pin]

            url = transactions_url + 'scheduled' 

            Dwolla.request(:delete, url, params, {}, token)
        end

        class << self
            alias_method :listing, :get
            alias_method :send, :create
        end

        private

        def self.transactions_url
            return '/transactions/'
        end
    end
end
