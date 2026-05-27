# frozen_string_literal: true

module BrightData
  # Top-level Bright Data API client.
  #
  # @example
  #   client = BrightData::Client.new(api_token: ENV.fetch("BRIGHTDATA_API_TOKEN"))
  #   client.linkedin
  class Client
    # @return [BrightData::HTTP] underlying HTTP wrapper
    attr_reader :http

    # @return [BrightData::LinkedIn::Namespace] LinkedIn endpoint namespace
    attr_reader :linkedin

    # @param api_token [String] Bright Data API token
    # @param base_url [String] override Bright Data API base URL
    # @param logger [Logger, nil] optional logger for request tracing
    # @raise [BrightData::ConfigurationError] if `api_token` is nil or empty
    def initialize(api_token:, base_url: BrightData::HTTP::BASE_URL, logger: nil)
      @http = HTTP.new(api_token:, base_url:, logger:)
      @linkedin = LinkedIn::Namespace.new(http: @http)
    end
  end
end
