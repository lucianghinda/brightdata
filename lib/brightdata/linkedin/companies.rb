# frozen_string_literal: true

module BrightData
  module LinkedIn
    # `client.linkedin.companies` endpoint family for LinkedIn companies by URL.
    #
    # @example Trigger an async collection
    #   snapshot = client.linkedin.companies.trigger(urls: ["https://www.linkedin.com/company/example/"])
    # @example Scrape synchronously
    #   companies = client.linkedin.companies.scrape(urls: ["https://www.linkedin.com/company/example/"])
    #
    # @!method trigger(urls:)
    #   @param urls [Array<String>] LinkedIn company URLs
    #   @return [BrightData::Snapshot]
    #   @raise [BrightData::ArgumentError] if `urls` is not an Array
    # @!method scrape(urls:)
    #   @param urls [Array<String>] LinkedIn company URLs
    #   @return [Array<BrightData::LinkedIn::Types::Company>]
    #   @raise [BrightData::ArgumentError] if `urls` is not an Array
    #   @raise [BrightData::ScrapeTimeoutError] when results exceed Bright Data's synchronous cap
    class Companies
      include Endpoint

      endpoint(
        dataset_key: :companies_collect_by_url,
        input: Types::CompanyUrlInput,
        result: Types::Company,
        param: :urls
      )
    end
  end
end
