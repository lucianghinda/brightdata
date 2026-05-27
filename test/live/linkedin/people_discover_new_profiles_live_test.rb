# frozen_string_literal: true

require "test_helper"

module BrightData
  module LinkedIn
    class PeopleDiscoverNewProfilesLiveTest < Minitest::Test
      include LiveScrapeHelper

      def setup
        skip "Set BRIGHTDATA_LIVE=1 and BRIGHTDATA_API_TOKEN to run" unless ENV["BRIGHTDATA_LIVE"]

        @client = BrightData::Client.new(api_token: ENV.fetch("BRIGHTDATA_API_TOKEN"))
      end

      def test_scrape_returns_discovered_profile_array
        profiles = live_results(
          name: "people_discover_new_profiles",
          scrape: -> { @client.linkedin.people.discover_new_profiles.scrape(queries: [query]) },
          trigger: -> { @client.linkedin.people.discover_new_profiles.trigger(queries: [query]) }
        )

        assert_live_results_present!("people_discover_new_profiles", profiles)
        assert_instance_of BrightData::LinkedIn::Types::DiscoveredProfile, profiles.first
      end

      private

      def query
        BrightData::LinkedIn::Types::PeopleDiscoverInput.new(
          url: "https://www.linkedin.com",
          first_name: "james",
          last_name: "smith"
        )
      end
    end
  end
end
