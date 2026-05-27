# frozen_string_literal: true

require "test_helper"

module BrightData
  module LinkedIn
    class JobsDiscoverByUrlTest < Minitest::Test
      def test_scrape_returns_job_array
        stub_scrape

        job = discover_by_url.scrape(urls: [search_url]).first

        assert_equal "Senior Ruby Developer", job.job_title
      end

      def test_request_includes_discover_query_params
        stub_scrape

        discover_by_url.scrape(urls: [search_url])

        assert_requested :post, "#{HTTP::BASE_URL}/datasets/v3/scrape", query: expected_query
      end

      def test_trigger_returns_snapshot
        stub_request(:post, "#{HTTP::BASE_URL}/datasets/v3/trigger")
          .with(query: expected_query)
          .to_return_json(body: { snapshot_id: "s_jobs_url" })

        snapshot = discover_by_url.trigger(urls: [search_url])

        assert_equal "s_jobs_url", snapshot.id
      end

      def test_urls_must_be_an_array
        error = assert_raises(BrightData::ArgumentError) { discover_by_url.scrape(urls: search_url) }

        assert_match "urls: must be an Array", error.message
      end

      private

      def discover_by_url
        Client.new(api_token: "token").linkedin.jobs.discover_by_url
      end

      def search_url
        "https://www.linkedin.com/jobs/search/?keywords=ruby"
      end

      def expected_query
        { dataset_id: Datasets.id_for(:jobs_discover_by_url), type: "discover_new", discover_by: "url" }
      end

      def stub_scrape
        stub_request(:post, "#{HTTP::BASE_URL}/datasets/v3/scrape")
          .with(query: expected_query)
          .to_return(status: 200, body: fixture("linkedin/jobs_discover_by_url_response.json"), headers: { "Content-Type" => "application/json" })
      end

      def fixture(name)
        File.read(File.expand_path("../../fixtures/#{name}", __dir__))
      end
    end
  end
end
