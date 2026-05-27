# frozen_string_literal: true

require "test_helper"

module BrightData
  module LinkedIn
    class JobsDiscoverByKeywordLiveTest < Minitest::Test
      include LiveScrapeHelper

      def setup
        skip "LinkedIn jobs live tests are disabled because each run is expensive"
        skip "Set BRIGHTDATA_LIVE=1 and BRIGHTDATA_API_TOKEN to run" unless ENV["BRIGHTDATA_LIVE"]

        @client = BrightData::Client.new(api_token: ENV.fetch("BRIGHTDATA_API_TOKEN"))
      end

      def test_scrape_returns_job_array
        jobs = live_results(
          name: "jobs_discover_by_keyword",
          scrape: -> { @client.linkedin.jobs.discover_by_keyword.scrape(queries: [query]) },
          trigger: -> { @client.linkedin.jobs.discover_by_keyword.trigger(queries: [query]) }
        )

        assert_live_results_present!("jobs_discover_by_keyword", jobs)
        assert_instance_of BrightData::LinkedIn::Types::Job, jobs.first
      end

      private

      def query
        BrightData::LinkedIn::Types::JobKeywordInput.new(
          location: "New York",
          keyword: "ruby",
          country: nil,
          time_range: nil,
          job_type: nil,
          experience_level: nil,
          remote: nil,
          company: nil,
          selective_search: nil,
          jobs_to_not_include: nil,
          location_radius: nil
        )
      end
    end
  end
end
