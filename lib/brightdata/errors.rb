# frozen_string_literal: true

module BrightData
  # Base error class. Rescue this to catch any BrightData failure.
  class Error < StandardError; end

  # Raised when the gem is misconfigured, for example when `api_token` is blank.
  class ConfigurationError < Error; end

  # Raised when a caller passes an invalid argument shape or value.
  #
  # This class intentionally inherits from {BrightData::Error}, not from
  # `::ArgumentError`. Use `rescue BrightData::ArgumentError` or
  # `rescue BrightData::Error`.
  class ArgumentError < Error; end

  # Raised on 401/403 responses from the Bright Data API.
  class AuthError < Error; end

  # Base class for transport-level errors.
  class HTTPError < Error
    # @return [Integer, nil] HTTP status, or nil if the request never completed
    attr_reader :status

    # @return [String, nil] raw response body
    attr_reader :body

    # @return [Net::HTTPResponse, nil] raw Net::HTTP response
    attr_reader :response

    # @param message [String] human-readable error message
    # @param status [Integer, nil] HTTP status, or nil if unavailable
    # @param body [String, nil] raw response body
    # @param response [Net::HTTPResponse, nil] raw Net::HTTP response
    def initialize(message, status: nil, body: nil, response: nil)
      super(message)
      @status = status
      @body = body
      @response = response
    end
  end

  # Raised on 429 Too Many Requests responses.
  class RateLimitError < HTTPError
    # @return [Integer, nil] value of the `Retry-After` header in seconds, or nil if absent
    attr_reader :retry_after

    # @param message [String] human-readable error message
    # @param status [Integer] HTTP status
    # @param body [String, nil] raw response body
    # @param response [Net::HTTPResponse, nil] raw Net::HTTP response
    # @param retry_after [Integer, nil] retry delay in seconds
    def initialize(message, status: 429, body: nil, response: nil, retry_after: nil)
      super(message, status:, body:, response:)
      @retry_after = retry_after
    end
  end

  # Raised on 5xx responses from the Bright Data API.
  class ServerError < HTTPError; end

  # Raised when `/scrape` exceeds Bright Data's 60-second synchronous cap.
  class ScrapeTimeoutError < Error
    # @return [String] snapshot ID returned by Bright Data
    attr_reader :snapshot_id

    # @return [BrightData::Snapshot, nil] resumable snapshot returned by Bright Data
    attr_reader :snapshot

    # @param message [String] human-readable error message
    # @param snapshot_id [String] snapshot ID returned by Bright Data
    # @param snapshot [BrightData::Snapshot, nil] snapshot object that can be waited on
    def initialize(message, snapshot_id:, snapshot: nil)
      super(message)
      @snapshot_id = snapshot_id
      @snapshot = snapshot
    end
  end

  # Raised by explicit exception-based snapshot failure flows.
  #
  # `Snapshot#wait` normally returns `SimpleResult::Failure` on failed
  # snapshots. This class is reserved for callers who opt into exception
  # semantics in future API versions.
  class SnapshotFailedError < Error
    # @return [String] snapshot ID
    attr_reader :snapshot_id

    # @return [Hash, nil] failure details returned by Bright Data
    attr_reader :details

    # @param message [String] human-readable error message
    # @param snapshot_id [String] snapshot ID
    # @param details [Hash, nil] failure details returned by Bright Data
    def initialize(message, snapshot_id:, details: nil)
      super(message)
      @snapshot_id = snapshot_id
      @details = details
    end
  end
end
