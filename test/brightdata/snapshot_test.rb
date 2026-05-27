# frozen_string_literal: true

require "test_helper"

module BrightData
  class SnapshotTest < Minitest::Test
    def test_wait_returns_success_with_parsed_results_when_running_then_ready
      snapshot = TestSnapshot.new(
        id: "s_123",
        http: FakeSnapshotHTTP.new(progresses: [running_payload, ready_payload], results: [{ id: "raw" }]),
        result_parser: ->(raw) { raw.map { |item| item.fetch(:id) } }
      )

      result = snapshot.wait(poll_interval: 0)

      assert_equal ["raw"], result.payload
    end

    def test_wait_sleeps_between_starting_running_and_ready_polls
      snapshot = TestSnapshot.new(
        id: "s_123",
        http: FakeSnapshotHTTP.new(progresses: [starting_payload, running_payload, ready_payload], results: []),
        result_parser: ->(raw) { raw }
      )

      snapshot.wait(poll_interval: 2)

      assert_equal [2, 2], snapshot.sleep_calls
    end

    def test_wait_returns_failure_with_failed_payload
      failed = failed_payload
      snapshot = TestSnapshot.new(
        id: "s_123",
        http: FakeSnapshotHTTP.new(progresses: [failed, failed], results: [])
      )

      result = snapshot.wait(poll_interval: 0)

      assert_equal failed, result.error
    end

    def test_wait_timeout_raises_scrape_timeout_error_with_snapshot_id
      snapshot = TestSnapshot.new(
        id: "s_timeout",
        http: FakeSnapshotHTTP.new(progresses: [running_payload, running_payload], results: [])
      )

      error = assert_raises(ScrapeTimeoutError) { snapshot.wait(timeout: 0, poll_interval: 0) }
      assert_equal "s_timeout", error.snapshot_id
    end

    def test_custom_poll_interval_is_passed_to_sleep_for
      snapshot = TestSnapshot.new(
        id: "s_123",
        http: FakeSnapshotHTTP.new(progresses: [running_payload, ready_payload], results: [])
      )

      snapshot.wait(poll_interval: 7)

      assert_equal [7], snapshot.sleep_calls
    end

    def test_custom_result_parser_receives_raw_array
      raw_results = [{ id: "item-1" }]
      parser_inputs = []
      snapshot = TestSnapshot.new(
        id: "s_123",
        http: FakeSnapshotHTTP.new(progresses: [ready_payload], results: raw_results),
        result_parser: lambda { |raw|
          parser_inputs << raw
          :parsed
        }
      )

      snapshot.wait

      assert_equal [raw_results], parser_inputs
    end

    def test_default_parser_returns_raw_unchanged
      raw_results = [{ id: "item-1" }]
      snapshot = TestSnapshot.new(
        id: "s_123",
        http: FakeSnapshotHTTP.new(progresses: [ready_payload], results: raw_results)
      )

      assert_equal raw_results, snapshot.wait.payload
    end

    def test_unknown_status_raises_bright_data_error
      snapshot = TestSnapshot.new(
        id: "s_123",
        http: FakeSnapshotHTTP.new(progresses: [{ status: "mystery" }], results: [])
      )

      assert_raises(Error) { snapshot.progress }
    end

    def test_infinite_timeout_does_not_raise_while_eventually_ready
      snapshot = TestSnapshot.new(
        id: "s_123",
        http: FakeSnapshotHTTP.new(progresses: Array.new(100, running_payload) + [ready_payload], results: [])
      )

      assert snapshot.wait(timeout: Float::INFINITY, poll_interval: 0).success?
    end

    def test_results_fetches_snapshot_json_path
      http = FakeSnapshotHTTP.new(progresses: [], results: [{ id: "item-1" }])
      snapshot = TestSnapshot.new(id: "s_123", http:)

      snapshot.results

      assert_equal({ path: "/datasets/v3/snapshot/s_123", query: { format: "json" } }, http.requests.last)
    end

    def test_ready_and_failed_reflect_status
      snapshot = TestSnapshot.new(id: "s_123", http: FakeSnapshotHTTP.new(progresses: [ready_payload], results: []))
      snapshot.progress

      assert_equal [true, false], [snapshot.ready?, snapshot.failed?]
    end

    private

    def starting_payload = { status: "starting" }
    def running_payload = { status: "running" }
    def ready_payload = { status: "ready" }
    def failed_payload = { status: "failed", error: "collection_failed" }

    class TestSnapshot < Snapshot
      attr_reader :sleep_calls

      def initialize(...)
        super
        @sleep_calls = []
      end

      private

      def sleep_for(seconds)
        @sleep_calls << seconds
      end
    end

    class FakeSnapshotHTTP
      attr_reader :requests

      def initialize(progresses:, results:)
        @progresses = progresses.dup
        @results = results
        @requests = []
      end

      def get(path:, query: {})
        @requests << { path:, query: }
        return @results if path.start_with?("/datasets/v3/snapshot/")

        @progresses.shift || @progresses.last
      end
    end
  end
end
