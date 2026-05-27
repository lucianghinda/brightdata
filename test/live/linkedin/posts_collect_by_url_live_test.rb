# frozen_string_literal: true

require "test_helper"

module BrightData
  module LinkedIn
    class PostsCollectByUrlLiveTest < Minitest::Test
      include LiveScrapeHelper

      def setup
        skip "Set BRIGHTDATA_LIVE=1 and BRIGHTDATA_API_TOKEN to run" unless ENV["BRIGHTDATA_LIVE"]

        @client = BrightData::Client.new(api_token: ENV.fetch("BRIGHTDATA_API_TOKEN"))
      end

      def test_scrape_returns_post_array
        posts = live_results(
          name: "posts_collect_by_url",
          scrape: -> { @client.linkedin.posts.collect_by_url.scrape(urls: urls) },
          trigger: -> { @client.linkedin.posts.collect_by_url.trigger(urls: urls) }
        )

        assert_live_results_present!("posts_collect_by_url", posts)
        assert_instance_of BrightData::LinkedIn::Types::Post, posts.first
      end

      private

      def urls
        ["https://www.linkedin.com/posts/example"]
      end
    end
  end
end
