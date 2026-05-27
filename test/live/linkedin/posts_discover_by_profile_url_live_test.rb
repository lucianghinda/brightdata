# frozen_string_literal: true

require "test_helper"

module BrightData
  module LinkedIn
    class PostsDiscoverByProfileUrlLiveTest < Minitest::Test
      include LiveScrapeHelper

      def setup
        skip "Set BRIGHTDATA_LIVE=1 and BRIGHTDATA_API_TOKEN to run" unless ENV["BRIGHTDATA_LIVE"]

        @client = BrightData::Client.new(api_token: ENV.fetch("BRIGHTDATA_API_TOKEN"))
      end

      def test_scrape_returns_post_array
        posts = live_results(
          name: "posts_discover_by_profile_url",
          scrape: -> { @client.linkedin.posts.discover_by_profile_url.scrape(profile_urls: urls) },
          trigger: -> { @client.linkedin.posts.discover_by_profile_url.trigger(profile_urls: urls) }
        )

        assert_live_results_present!("posts_discover_by_profile_url", posts, strict: true)
        assert_instance_of BrightData::LinkedIn::Types::Post, posts.first
      end

      private

      def urls
        [ENV.fetch("BRIGHTDATA_LIVE_POSTS_PROFILE_URL", "https://www.linkedin.com/in/elad-moshe-05a90413/")]
      end
    end
  end
end
