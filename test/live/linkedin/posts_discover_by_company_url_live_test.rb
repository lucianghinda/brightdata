# frozen_string_literal: true

require "test_helper"

module BrightData
  module LinkedIn
    class PostsDiscoverByCompanyUrlLiveTest < Minitest::Test
      include LiveScrapeHelper

      def setup
        skip "Set BRIGHTDATA_LIVE=1 and BRIGHTDATA_API_TOKEN to run" unless ENV["BRIGHTDATA_LIVE"]

        @client = BrightData::Client.new(api_token: ENV.fetch("BRIGHTDATA_API_TOKEN"))
      end

      def test_scrape_returns_post_array
        posts = live_results(
          name: "posts_discover_by_company_url",
          scrape: -> { @client.linkedin.posts.discover_by_company_url.scrape(company_urls: urls) },
          trigger: -> { @client.linkedin.posts.discover_by_company_url.trigger(company_urls: urls) }
        )

        assert_live_results_present!("posts_discover_by_company_url", posts, strict: true)
        assert_instance_of BrightData::LinkedIn::Types::Post, posts.first
      end

      private

      def urls
        [ENV.fetch("BRIGHTDATA_LIVE_POSTS_COMPANY_URL", "https://www.linkedin.com/company/bright-data/")]
      end
    end
  end
end
