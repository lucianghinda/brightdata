# frozen_string_literal: true

require "test_helper"

module BrightData
  module LinkedIn
    class EndpointTest < Minitest::Test
      Input = Data.define(:url)

      ApiHashInput = Data.define(:url) do
        def to_api_hash
          { custom_url: url }
        end
      end

      def test_trigger_with_returns_snapshot_with_response_snapshot_id
        endpoint = FakeEndpoint.new(http: FakeHTTP.new([{ snapshot_id: "s_test123" }]))

        snapshot = endpoint.trigger(inputs: [Input.new(url: "https://example.com")])

        assert_equal "s_test123", snapshot.id
      end

      def test_scrape_with_returns_parsed_array_for_array_payload
        endpoint = FakeEndpoint.new(http: FakeHTTP.new([[{ id: 1 }]]))

        assert_equal [{ parsed: { id: 1 } }], endpoint.scrape(inputs: [])
      end

      def test_scrape_with_raises_scrape_timeout_error_for_snapshot_fallback
        endpoint = FakeEndpoint.new(http: FakeHTTP.new([{ snapshot_id: "s_later" }]))

        error = assert_raises(ScrapeTimeoutError) { endpoint.scrape(inputs: []) }
        assert_equal "s_later", error.snapshot_id
        assert_instance_of Snapshot, error.snapshot
        assert_equal "s_later", error.snapshot.id
      end

      def test_trigger_posts_to_trigger_path_with_dataset_and_extra_query
        http = FakeHTTP.new([{ snapshot_id: "s_test123" }])
        endpoint = FakeEndpoint.new(http:)

        endpoint.trigger(inputs: [], extra_query: { type: "discover_new" })

        assert_equal(
          { path: Endpoint::TRIGGER_PATH, query: { dataset_id: Datasets.id_for(:profiles_collect_by_url), type: "discover_new" },
            body: { input: [] } }, http.requests.last
        )
      end

      def test_scrape_posts_to_scrape_path_with_dataset_and_extra_query
        http = FakeHTTP.new([[]])
        endpoint = FakeEndpoint.new(http:)

        endpoint.scrape(inputs: [], extra_query: { discover_by: "url" })

        assert_equal(
          { path: Endpoint::SCRAPE_PATH, query: { dataset_id: Datasets.id_for(:profiles_collect_by_url), discover_by: "url" },
            body: { input: [] } }, http.requests.last
        )
      end

      def test_serialize_inputs_uses_to_api_hash_when_available
        http = FakeHTTP.new([{ snapshot_id: "s_test123" }])
        endpoint = FakeEndpoint.new(http:)

        endpoint.trigger(inputs: [ApiHashInput.new(url: "https://example.com")])

        assert_equal({ input: [{ custom_url: "https://example.com" }] }, http.requests.last.fetch(:body))
      end

      def test_serialize_inputs_falls_back_to_to_h
        http = FakeHTTP.new([{ snapshot_id: "s_test123" }])
        endpoint = FakeEndpoint.new(http:)

        endpoint.trigger(inputs: [Input.new(url: "https://example.com")])

        assert_equal({ input: [{ url: "https://example.com" }] }, http.requests.last.fetch(:body))
      end

      class FakeEndpoint
        include Endpoint

        def initialize(http:)
          @http = http
        end

        def trigger(inputs:, extra_query: {})
          trigger_with(dataset_key: :profiles_collect_by_url, inputs:, extra_query:)
        end

        def scrape(inputs:, extra_query: {})
          scrape_with(dataset_key: :profiles_collect_by_url, inputs:, extra_query:)
        end

        private

        def result_parser
          ->(raw) { raw.map { |item| { parsed: item } } }
        end
      end

      class FakeHTTP
        attr_reader :requests

        def initialize(responses)
          @responses = responses
          @requests = []
        end

        def post(path:, query:, body:)
          @requests << { path:, query:, body: }
          @responses.shift
        end
      end
    end
  end
end
