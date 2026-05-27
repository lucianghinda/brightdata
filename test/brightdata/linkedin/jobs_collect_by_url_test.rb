# frozen_string_literal: true

require "test_helper"

module BrightData
  module LinkedIn
    class JobsCollectByUrlTest < Minitest::Test
      def test_scrape_returns_job_array_with_raw_payload
        stub_scrape

        job = collect_by_url.scrape(urls: [job_url]).first

        assert_equal ["Ruby Developer", "kept in raw"], [job.job_title, job.raw.fetch(:unexpected_field)]
      end

      def test_trigger_returns_snapshot
        stub_request(:post, "#{HTTP::BASE_URL}/datasets/v3/trigger")
          .with(query: { dataset_id: Datasets.id_for(:jobs_collect_by_url) })
          .to_return_json(body: { snapshot_id: "s_jobs" })

        snapshot = collect_by_url.trigger(urls: [job_url])

        assert_equal "s_jobs", snapshot.id
      end

      def test_empty_urls_array_returns_empty_array
        assert_equal [], collect_by_url.scrape(urls: [])
      end

      def test_urls_must_be_an_array
        error = assert_raises(BrightData::ArgumentError) { collect_by_url.scrape(urls: job_url) }

        assert_match "urls: must be an Array", error.message
      end

      def test_request_url_contains_dataset_id
        stub_scrape

        collect_by_url.scrape(urls: [job_url])

        assert_requested :post, "#{HTTP::BASE_URL}/datasets/v3/scrape", query: { dataset_id: Datasets.id_for(:jobs_collect_by_url) }
      end

      def test_jobs_inspect_mentions_all_modes
        assert_equal "#<BrightData::LinkedIn::Jobs modes=[:collect_by_url, :discover_by_url, :discover_by_keyword]>",
                     jobs.inspect
      end

      private

      def jobs
        Client.new(api_token: "token").linkedin.jobs
      end

      def collect_by_url
        jobs.collect_by_url
      end

      def job_url
        "https://www.linkedin.com/jobs/view/123/"
      end

      def stub_scrape
        stub_request(:post, "#{HTTP::BASE_URL}/datasets/v3/scrape")
          .with(query: { dataset_id: Datasets.id_for(:jobs_collect_by_url) })
          .to_return(status: 200, body: fixture("linkedin/jobs_collect_by_url_response.json"), headers: { "Content-Type" => "application/json" })
      end

      def fixture(name)
        File.read(File.expand_path("../../fixtures/#{name}", __dir__))
      end
    end
  end
end
