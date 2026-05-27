# frozen_string_literal: true

require "test_helper"

module BrightData
  module LinkedIn
    class ProfilesTest < Minitest::Test
      def test_scrape_returns_profile_array_with_raw_payload
        stub_scrape

        profile = profiles.scrape(urls: [profile_url]).first

        assert_equal ["Example Person", "kept in raw"], [profile.name, profile.raw.fetch(:unexpected_field)]
      end

      def test_trigger_returns_snapshot
        stub_request(:post, "#{HTTP::BASE_URL}/datasets/v3/trigger")
          .with(query: { dataset_id: Datasets.id_for(:profiles_collect_by_url) })
          .to_return_json(body: { snapshot_id: "s_profiles" })

        snapshot = profiles.trigger(urls: [profile_url])

        assert_equal "s_profiles", snapshot.id
      end

      def test_empty_urls_array_returns_empty_array
        assert_equal [], profiles.scrape(urls: [])
      end

      def test_urls_must_be_an_array
        error = assert_raises(BrightData::ArgumentError) { profiles.scrape(urls: profile_url) }

        assert_match "urls: must be an Array", error.message
      end

      def test_request_url_contains_dataset_id
        stub_scrape

        profiles.scrape(urls: [profile_url])

        assert_requested :post, "#{HTTP::BASE_URL}/datasets/v3/scrape", query: { dataset_id: Datasets.id_for(:profiles_collect_by_url) }
      end

      def test_scrape_accepts_nested_live_result_arrays
        stub_request(:post, "#{HTTP::BASE_URL}/datasets/v3/scrape")
          .with(query: { dataset_id: Datasets.id_for(:profiles_collect_by_url) })
          .to_return_json(body: [[{ name: "Nested Person" }]])

        profile = profiles.scrape(urls: [profile_url]).first

        assert_equal "Nested Person", profile.name
      end

      private

      def profiles
        Client.new(api_token: "token").linkedin.profiles
      end

      def profile_url
        "https://www.linkedin.com/in/example-person/"
      end

      def stub_scrape
        stub_request(:post, "#{HTTP::BASE_URL}/datasets/v3/scrape")
          .with(query: { dataset_id: Datasets.id_for(:profiles_collect_by_url) })
          .to_return(status: 200, body: fixture("linkedin/profiles_scrape_response.json"), headers: { "Content-Type" => "application/json" })
      end

      def fixture(name)
        File.read(File.expand_path("../../fixtures/#{name}", __dir__))
      end
    end
  end
end
