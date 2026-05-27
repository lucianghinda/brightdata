# frozen_string_literal: true

require "test_helper"

module BrightData
  module LinkedIn
    class JobsCollectByUrlLiveTest < Minitest::Test
      include LiveScrapeHelper

      def setup
        skip "LinkedIn jobs live tests are disabled because each run is expensive"
        skip "Set BRIGHTDATA_LIVE=1 and BRIGHTDATA_API_TOKEN to run" unless ENV["BRIGHTDATA_LIVE"]

        @client = BrightData::Client.new(api_token: ENV.fetch("BRIGHTDATA_API_TOKEN"))
      end

      def test_scrape_returns_job_array
        jobs = live_results(
          name: "jobs_collect_by_url",
          scrape: -> { @client.linkedin.jobs.collect_by_url.scrape(urls: urls) },
          trigger: -> { @client.linkedin.jobs.collect_by_url.trigger(urls: urls) }
        )

        assert_live_results_present!("jobs_collect_by_url", jobs)
        assert_instance_of BrightData::LinkedIn::Types::Job, jobs.first
      end

      private

      def urls
        ["https://www.linkedin.com/jobs/view/123/"]
      end
    end
  end
end
