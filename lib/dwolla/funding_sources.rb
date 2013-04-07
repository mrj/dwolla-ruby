module Dwolla
    class FundingSources
        def self.get(id=nil)
            url = funding_sources_url

            url += id.to_s unless id.nil?

            Dwolla.request(:get, url)
        end

        def self.withdraw(id=nil, params={})
            raise MissingParameterError.new('No Funding Source ID Provided.') if id.nil?
            raise MissingParameterError.new('No PIN Provided.') unless params[:pin]
            raise MissingParameterError.new('No Amount Provided.') unless params[:amount]

            url = funding_sources_url
            url += id.to_s + '/withdraw'

            Dwolla.request(:post, url, params)
        end

        def self.deposit(id=nil, params={})
            raise MissingParameterError.new('No Funding Source ID Provided.') if id.nil?
            raise MissingParameterError.new('No PIN Provided.') unless params[:pin]
            raise MissingParameterError.new('No Amount Provided.') unless params[:amount]

            url = funding_sources_url
            url += id.to_s + '/deposit'

            Dwolla.request(:post, url, params)
        end

        def self.add(params={})
            raise MissingParameterError.new('No Account Number Provided.') unless params[:account_number]
            raise MissingParameterError.new('No Routing Number (ABA) Provided.') unless params[:routing_number]
            raise MissingParameterError.new('No Account Type Provided.') unless params[:account_type]
            raise MissingParameterError.new('No Account Name Provided.') unless params[:name]

            url = funding_sources_url

            Dwolla.request(:post, url, params)
        end

        def self.verify(id=nil, params={})
            raise MissingParameterError.new('No Funding Source ID Provided.') if id.nil?
            raise MissingParameterError.new('No Deposit 1 Amount Provided.') unless params[:deposit1]
            raise MissingParameterError.new('No Deposit 2 Amount Provided.') unless params[:deposit2]

            url = funding_sources_url
            url += id.to_s + '/verify'

            Dwolla.request(:post, url, params)
        end

        class << self
            alias_method :listing, :get
        end

        private

        def self.funding_sources_url
            return '/fundingsources/'
        end
    end
end
