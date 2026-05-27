# frozen_string_literal: true

require "test_helper"

module BrightData
  module LinkedIn
    class PeopleDiscoverNewProfilesTest < Minitest::Test
      def test_scrape_returns_discovered_profile_array
        stub_scrape

        profile = discover.scrape(queries: [query]).first

        assert_equal ["Example Person", "kept in raw"], [profile.name, profile.raw.fetch(:unexpected_field)]
      end

      def test_request_includes_discover_query_params
        stub_scrape

        discover.scrape(queries: [query])

        assert_requested :post, "#{HTTP::BASE_URL}/datasets/v3/scrape", query: expected_query
      end

      def test_trigger_returns_snapshot
        stub_request(:post, "#{HTTP::BASE_URL}/datasets/v3/trigger")
          .with(query: expected_query)
          .to_return_json(body: { snapshot_id: "s_people" })

        snapshot = discover.trigger(queries: [query])

        assert_equal "s_people", snapshot.id
      end

      def test_people_discover_input_to_api_hash_omits_nil_values
        input = Types::PeopleDiscoverInput.new(url: "https://www.linkedin.com", first_name: "Jane", last_name: nil)

        assert_equal({ url: "https://www.linkedin.com", first_name: "Jane" }, input.to_api_hash)
      end

      def test_queries_must_be_people_discover_inputs
        error = assert_raises(BrightData::ArgumentError) { discover.scrape(queries: [Object.new]) }

        assert_match "queries[] must be PeopleDiscoverInput", error.message
      end

      def test_people_inspect_mentions_mode
        assert_equal "#<BrightData::LinkedIn::People modes=[:discover_new_profiles]>",
                     Client.new(api_token: "token").linkedin.people.inspect
      end

      private

      def discover
        Client.new(api_token: "token").linkedin.people.discover_new_profiles
      end

      def query
        Types::PeopleDiscoverInput.new(url: "https://www.linkedin.com", first_name: "Jane", last_name: "Smith")
      end

      def expected_query
        { dataset_id: Datasets.id_for(:people_discover_new_profiles) }
      end

      def stub_scrape
        stub_request(:post, "#{HTTP::BASE_URL}/datasets/v3/scrape")
          .with(query: expected_query)
          .to_return(status: 200, body: fixture("linkedin/people_discover_new_profiles_response.json"), headers: { "Content-Type" => "application/json" })
      end

      def fixture(name)
        File.read(File.expand_path("../../fixtures/#{name}", __dir__))
      end
    end
  end
end
