module Dwolla
  class MassPay

    def self.get(token=nil)
      Dwolla.request(:get, masspay_url, {}, {}, token);
    end

    def self.create(params={}, token=nil)
      raise MissingParameterError.new('No fundsSource ID Provided.') unless params[:fundsSource]
      raise MissingParameterError.new('No PIN Provided.') unless params[:pin]
      raise MissingParameterError.new('No Items Provided.') unless params[:items]

      Dwolla.request(:post, masspay_url, params, {}, token)
    end

    def self.getItems(id=nil, params={}, token=nil)
      raise MissingParameterError.new('No MassPay Job ID Provided.') if id.nil?
      url = masspay_url
      url += id.to_s unless id.nil? += '/items'

      Dwolla.request(:get, url, params, {}, token)
    end

    def self.getItem(jobId=nil, itemId=nil, token=nil)
      raise MissingParameterError.new('No MassPay Job ID Provided.') if jobId.nil?
      raise MissingParameterError.new('No Item ID Provided.') if itemId.nil?

      url = masspay_url
      url += jobId.to_s unless jobId.nil? += '/items/' += itemId.to_s unless itemId.nil?

      Dwolla.request(:get, url, {}, {}, token)
    end

    def self.getJob(id=nil, token=nil)
      raise MissingParameterError.new('No MassPay Job ID Provided.') if id.nil?

      url = masspay_url
      url += id.to_s unless id.nil?

      Dwolla.request(:get, url, {}, token)
    end

    private

    def self.masspay_url
      return '/masspay/'
    end

  end
end