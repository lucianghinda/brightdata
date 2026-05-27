# frozen_string_literal: true

require "test_helper"

module BrightData
  class ErrorsTest < Minitest::Test
    def test_base_error_inherits_from_standard_error
      assert_operator Error, :<, StandardError
    end

    def test_configuration_error_inherits_from_bright_data_error
      assert_operator ConfigurationError, :<, Error
    end

    def test_argument_error_does_not_inherit_from_stdlib_argument_error
      refute_operator BrightData::ArgumentError, :<, ::ArgumentError
    end

    def test_auth_error_inherits_from_bright_data_error
      assert_operator AuthError, :<, Error
    end

    def test_http_error_retains_status_body_and_response
      response = Object.new
      error = HTTPError.new("boom", status: 418, body: "teapot", response:)

      assert_equal [418, "teapot", response], [error.status, error.body, error.response]
    end

    def test_rate_limit_error_retains_retry_after
      error = RateLimitError.new("slow down", retry_after: 30)

      assert_equal [429, 30], [error.status, error.retry_after]
    end

    def test_server_error_inherits_from_http_error
      assert_operator ServerError, :<, HTTPError
    end

    def test_scrape_timeout_error_retains_snapshot_id
      error = ScrapeTimeoutError.new("timeout", snapshot_id: "s_123")

      assert_equal "s_123", error.snapshot_id
    end

    def test_scrape_timeout_error_can_retain_resumable_snapshot
      snapshot = Object.new
      error = ScrapeTimeoutError.new("timeout", snapshot_id: "s_123", snapshot:)

      assert_equal snapshot, error.snapshot
    end

    def test_snapshot_failed_error_retains_snapshot_id_and_details
      details = { status: "failed" }
      error = SnapshotFailedError.new("failed", snapshot_id: "s_123", details:)

      assert_equal ["s_123", details], [error.snapshot_id, error.details]
    end
  end
end
