# frozen_string_literal: true

require "test_helper"

module BrightData
  module LinkedIn
    class JobsDiscoverByKeywordTest < Minitest::Test
      def test_scrape_returns_job_array
        stub_scrape

        job = discover_by_keyword.scrape(queries: [query]).first

        assert_equal "Ruby Platform Engineer", job.job_title
      end

      def test_request_includes_discover_query_params
        stub_scrape

        discover_by_keyword.scrape(queries: [query])

        assert_requested :post, "#{HTTP::BASE_URL}/datasets/v3/scrape", query: expected_query
      end

      def test_trigger_returns_snapshot
        stub_request(:post, "#{HTTP::BASE_URL}/datasets/v3/trigger")
          .with(query: expected_query)
          .to_return_json(body: { snapshot_id: "s_jobs_keyword" })

        snapshot = discover_by_keyword.trigger(queries: [query])

        assert_equal "s_jobs_keyword", snapshot.id
      end

      def test_job_keyword_input_to_api_hash_omits_nil_values
        assert_equal({ location: "New York", keyword: "ruby" }, query.to_api_hash)
      end

      def test_queries_must_be_job_keyword_inputs
        error = assert_raises(BrightData::ArgumentError) { discover_by_keyword.scrape(queries: [Object.new]) }

        assert_match "queries[] must be JobKeywordInput", error.message
      end

      private

      def discover_by_keyword
        Client.new(api_token: "token").linkedin.jobs.discover_by_keyword
      end

      def query
        Types::JobKeywordInput.new(
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

      def expected_query
        { dataset_id: Datasets.id_for(:jobs_discover_by_keyword), type: "discover_new", discover_by: "keyword" }
      end

      def stub_scrape
        stub_request(:post, "#{HTTP::BASE_URL}/datasets/v3/scrape")
          .with(query: expected_query)
          .to_return(status: 200, body: fixture("linkedin/jobs_discover_by_keyword_response.json"), headers: { "Content-Type" => "application/json" })
      end

      def fixture(name)
        File.read(File.expand_path("../../fixtures/#{name}", __dir__))
      end
    end
  end
end
