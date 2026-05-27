# frozen_string_literal: true

require "json"
require "fileutils"

module BrightData
  # Optional request/response recorder, enabled by the `BRIGHTDATA_LIVE` env
  # var. Writes one JSON file per request, response, and error under `tmp/live`
  # so live API calls can be inspected after the fact.
  #
  # {HTTP} asks for a recorder via {.for}; when tracing is disabled it gets a
  # {Null} recorder whose methods are no-ops, keeping the HTTP request path free
  # of conditionals.
  #
  # @api private
  class LiveTrace
    # The request being traced. Groups the five related values {LiveTrace}
    # needs so they travel as one concept rather than a long parameter list.
    Request = Data.define(:method, :path, :query, :body, :uri) # rubocop:disable Lint/DataDefineOverride -- `method` mirrors the HTTP verb here; the Object#method shadow is intentional

    # Build a recorder and persist the request, or return a no-op recorder when
    # `BRIGHTDATA_LIVE` is unset.
    #
    # @param request [LiveTrace::Request] the request to trace
    # @return [LiveTrace, LiveTrace::Null]
    def self.for(request)
      return Null.new unless ENV["BRIGHTDATA_LIVE"]

      new(request).tap(&:record_request)
    end

    # No-op recorder used when tracing is disabled.
    class Null
      def record_request = nil

      def record_response(**) = nil

      def record_error(_error) = nil
    end

    def initialize(request)
      @request = request
      @trace_id = build_trace_id
    end

    def record_request
      save("request", request_payload)
      announce("request saved")
    end

    def record_response(response:, duration:)
      payload = response_payload(response, duration)
      save("response", payload)
      announce("response saved status=#{payload.fetch(:status)} duration=#{payload.fetch(:duration_seconds)}s")
    end

    def record_error(error)
      save("error", { error_class: error.class.name, message: error.message })
      announce("error saved #{error.class}: #{error.message}")
    end

    private

    def response_payload(response, duration)
      {
        status: response.code.to_i,
        duration_seconds: duration.round(3),
        headers: response.each_header.to_h,
        body: parsed_body(response.body.to_s)
      }
    end

    def request_payload # rubocop:disable Metrics/MethodLength -- a single flat payload hash, longer than 10 lines only by field count
      {
        method: @request.method.to_s.upcase,
        uri: @request.uri.to_s,
        path: @request.path,
        query: @request.query,
        body: @request.body,
        headers: {
          "Authorization" => "Bearer [REDACTED]",
          "Content-Type" => "application/json",
          "Accept" => "application/json"
        }
      }
    end

    def save(kind, payload)
      FileUtils.mkdir_p(output_dir)
      File.write(File.join(output_dir, "#{@trace_id}_#{kind}.json"), JSON.pretty_generate(payload))
    end

    def parsed_body(body)
      return nil if body.empty?

      JSON.parse(body)
    rescue JSON::ParserError
      parse_json_lines(body) || body.encode("UTF-8", invalid: :replace, undef: :replace, replace: "")
    end

    def parse_json_lines(body)
      lines = body.each_line.map(&:strip).reject(&:empty?)
      return if lines.empty?

      lines.map { |line| JSON.parse(line) }
    rescue JSON::ParserError
      nil
    end

    def build_trace_id
      stamp = Time.now.utc.strftime("%Y%m%d%H%M%S%6N")
      safe_path = @request.path.gsub(/[^a-zA-Z0-9]+/, "_").gsub(/\A_|_\z/, "")
      "#{stamp}_#{@request.method}_#{safe_path}"
    end

    def output_dir
      File.expand_path("../../tmp/live", __dir__)
    end

    def announce(message)
      puts "[live:http:#{@trace_id}] #{message} -> #{output_dir}"
    end
  end
end
