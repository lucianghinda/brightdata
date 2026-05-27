# frozen_string_literal: true

module BrightData
  module LinkedIn
    # `client.linkedin.profiles` endpoint family for LinkedIn profiles by URL.
    #
    # @example Trigger an async collection
    #   snapshot = client.linkedin.profiles.trigger(urls: ["https://www.linkedin.com/in/example/"])
    # @example Scrape synchronously
    #   profiles = client.linkedin.profiles.scrape(urls: ["https://www.linkedin.com/in/example/"])
    #
    # @!method trigger(urls:)
    #   @param urls [Array<String>] LinkedIn profile URLs
    #   @return [BrightData::Snapshot]
    #   @raise [BrightData::ArgumentError] if `urls` is not an Array
    # @!method scrape(urls:)
    #   @param urls [Array<String>] LinkedIn profile URLs
    #   @return [Array<BrightData::LinkedIn::Types::Profile>]
    #   @raise [BrightData::ArgumentError] if `urls` is not an Array
    #   @raise [BrightData::ScrapeTimeoutError] when results exceed Bright Data's synchronous cap
    class Profiles
      include Endpoint

      endpoint(
        dataset_key: :profiles_collect_by_url,
        input: Types::ProfileUrlInput,
        result: Types::Profile,
        param: :urls
      )
    end
  end
end
