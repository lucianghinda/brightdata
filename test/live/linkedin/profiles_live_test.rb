# frozen_string_literal: true

require "test_helper"

module BrightData
  module LinkedIn
    class ProfilesLiveTest < Minitest::Test
      include LiveScrapeHelper

      def setup
        skip "Set BRIGHTDATA_LIVE=1 and BRIGHTDATA_API_TOKEN to run" unless ENV["BRIGHTDATA_LIVE"]

        @client = BrightData::Client.new(api_token: ENV.fetch("BRIGHTDATA_API_TOKEN"))
      end

      def test_scrape_returns_profile_array
        profiles = live_results(
          name: "profiles",
          scrape: -> { @client.linkedin.profiles.scrape(urls: urls) },
          trigger: -> { @client.linkedin.profiles.trigger(urls: urls) }
        )

        assert_live_results_present!("profiles", profiles)
        assert_instance_of BrightData::LinkedIn::Types::Profile, profiles.first
      end

      private

      def urls
        ["https://www.linkedin.com/in/lucianghinda/"]
      end
    end
  end
end
