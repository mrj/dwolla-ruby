module Dwolla
    class Accounts
        def self.get_auto_withdrawal_status(funding_id=nil, token = nil)
          raise MissingParameterError.new('No Funding ID Provided.') if funding_id.nil?

          url = accounts_url + 'features/auto_withdrawl'

          Dwolla.request(:get, url, {}, {}, token)
        end

        def self.toggle_auto_withdrawl(enabled=true, funding_id=nil, token=nil)
            raise MissingParameterError.new('No Funding ID Provided.') if funding_id.nil?

            url = accounts_url + 'features/auto_withdrawl'
            params = {
                :enabled => enabled,
                :fundingId => funding_id
            }

            Dwolla.request(:post, url, params, {}, token)
        end

        private

        def self.accounts_url
            return '/accounts/'
        end
    end
end
