# frozen_string_literal: true

module BrightData
  # Represents a Bright Data Dataset job returned by every `.trigger` call.
  #
  # @example Wait for results
  #   snapshot = client.linkedin.profiles.trigger(urls: ["https://www.linkedin.com/in/example/"])
  #   result = snapshot.wait
  #   result.success? # => true
  class Snapshot
    # @return [Array<Symbol>] statuses recognized by Bright Data snapshot progress
    STATUSES = %i[starting running ready failed].freeze

    # @return [Symbol] trigger response key containing the snapshot ID
    TRIGGER_RESPONSE_KEY = :snapshot_id

    # @return [String] progress endpoint template
    PROGRESS_PATH_TEMPLATE = "/datasets/v3/progress/%s"

    # @return [String] results endpoint template
    RESULTS_PATH_TEMPLATE = "/datasets/v3/snapshot/%s"

    # @return [Integer] default wait timeout in seconds
    DEFAULT_TIMEOUT = 300

    # @return [Integer] default poll interval in seconds
    DEFAULT_POLL_INTERVAL = 5

    # @return [String] snapshot ID
    attr_reader :id

    # @return [Symbol] latest known status
    attr_reader :status

    # @param id [String] snapshot ID from `/datasets/v3/trigger`
    # @param http [BrightData::HTTP] HTTP wrapper
    # @param result_parser [#call] callable mapping raw result arrays to typed results
    def initialize(id:, http:, result_parser: ->(raw) { raw })
      @id = id
      @http = http
      @result_parser = result_parser
      @status = :starting
    end

    # Poll progress once.
    #
    # @return [Symbol] current snapshot status
    # @raise [BrightData::Error] if Bright Data returns an unknown status
    def progress
      @last_progress = @http.get(path: format(PROGRESS_PATH_TEMPLATE, @id))
      raw = @last_progress.fetch(:status)
      sym = raw.to_sym
      raise Error, "Unknown snapshot status from API: #{raw.inspect}" unless STATUSES.include?(sym)

      @status = sym
    end

    # @return [Boolean] true when the latest status is ready
    def ready? = @status == :ready

    # @return [Boolean] true when the latest status is failed
    def failed? = @status == :failed

    # Block until the snapshot reaches a terminal status or timeout elapses.
    #
    # @param timeout [Numeric] seconds to wait before raising
    # @param poll_interval [Numeric] seconds between progress polls
    # @return [SimpleResult::Success] success result containing parsed results
    # @return [SimpleResult::Failure] failure result containing the progress payload
    # @raise [BrightData::ScrapeTimeoutError] if timeout elapses before a terminal status
    def wait(timeout: DEFAULT_TIMEOUT, poll_interval: DEFAULT_POLL_INTERVAL)
      deadline = monotonic_now + timeout
      loop do
        result = poll_once(timeout:, deadline:, poll_interval:)
        return result if result
      end
    end

    # Fetch raw snapshot results.
    #
    # @return [Array] raw JSON result array
    def results
      @http.get(path: format(RESULTS_PATH_TEMPLATE, @id), query: { format: "json" })
    end

    private

    # Poll progress once; return a terminal Result, or nil to keep waiting.
    def poll_once(timeout:, deadline:, poll_interval:)
      progress
      return terminal_result if ready? || failed?
      raise timeout_error(timeout) if monotonic_now >= deadline

      sleep_for(poll_interval)
      nil
    end

    def terminal_result
      return Result.success(@result_parser.call(results)) if ready?

      Result.failure(failure_payload)
    end

    def timeout_error(timeout)
      ScrapeTimeoutError.new("Snapshot #{@id} still :#{@status} after #{timeout}s", snapshot_id: @id)
    end

    # Reuse the payload fetched by the failing #progress poll rather than
    # issuing a second identical request.
    def failure_payload
      @last_progress
    end

    def sleep_for(seconds)
      sleep(seconds)
    end

    def monotonic_now
      Process.clock_gettime(Process::CLOCK_MONOTONIC)
    end
  end
end
