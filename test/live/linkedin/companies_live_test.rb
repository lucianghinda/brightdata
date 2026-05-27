# frozen_string_literal: true

require "test_helper"

module BrightData
  module LinkedIn
    class CompaniesLiveTest < Minitest::Test
      include LiveScrapeHelper

      def setup
        skip "Set BRIGHTDATA_LIVE=1 and BRIGHTDATA_API_TOKEN to run" unless ENV["BRIGHTDATA_LIVE"]

        @client = BrightData::Client.new(api_token: ENV.fetch("BRIGHTDATA_API_TOKEN"))
      end

      def test_scrape_returns_company_array
        companies = live_results(
          name: "companies",
          scrape: -> { @client.linkedin.companies.scrape(urls: urls) },
          trigger: -> { @client.linkedin.companies.trigger(urls: urls) }
        )

        assert_live_results_present!("companies", companies)
        assert_instance_of BrightData::LinkedIn::Types::Company, companies.first
      end

      private

      def urls
        ["https://www.linkedin.com/company/searchapi/"]
      end
    end
  end
end
