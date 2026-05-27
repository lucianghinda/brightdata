# frozen_string_literal: true

require "test_helper"

module BrightData
  module LinkedIn
    class CompaniesTest < Minitest::Test
      def test_scrape_returns_company_array_with_raw_payload
        stub_scrape

        company = companies.scrape(urls: [company_url]).first

        assert_equal ["Example Company", "kept in raw"], [company.name, company.raw.fetch(:unexpected_field)]
      end

      def test_trigger_returns_snapshot
        stub_request(:post, "#{HTTP::BASE_URL}/datasets/v3/trigger")
          .with(query: { dataset_id: Datasets.id_for(:companies_collect_by_url) })
          .to_return_json(body: { snapshot_id: "s_companies" })

        snapshot = companies.trigger(urls: [company_url])

        assert_equal "s_companies", snapshot.id
      end

      def test_empty_urls_array_returns_empty_array
        assert_equal [], companies.scrape(urls: [])
      end

      def test_urls_must_be_an_array
        error = assert_raises(BrightData::ArgumentError) { companies.scrape(urls: company_url) }

        assert_match "urls: must be an Array", error.message
      end

      def test_request_url_contains_dataset_id
        stub_scrape

        companies.scrape(urls: [company_url])

        assert_requested :post, "#{HTTP::BASE_URL}/datasets/v3/scrape", query: { dataset_id: Datasets.id_for(:companies_collect_by_url) }
      end

      private

      def companies
        Client.new(api_token: "token").linkedin.companies
      end

      def company_url
        "https://www.linkedin.com/company/example/"
      end

      def stub_scrape
        stub_request(:post, "#{HTTP::BASE_URL}/datasets/v3/scrape")
          .with(query: { dataset_id: Datasets.id_for(:companies_collect_by_url) })
          .to_return(status: 200, body: fixture("linkedin/companies_scrape_response.json"), headers: { "Content-Type" => "application/json" })
      end

      def fixture(name)
        File.read(File.expand_path("../../fixtures/#{name}", __dir__))
      end
    end
  end
end
