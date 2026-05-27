# frozen_string_literal: true

require "json"
require "net/http"
require "openssl"
require "uri"

module BrightData
  # Thin Net::HTTP wrapper. Single point of egress for the gem.
  #
  # Optional request tracing lives in {LiveTrace}, kept out of this class so the
  # request path stays a small, readable Net::HTTP shim.
  class HTTP # rubocop:disable Metrics/ClassLength -- deliberately one cohesive HTTP shim; splitting it would scatter the request path
    # @return [String] default Bright Data API base URL
    BASE_URL = "https://api.brightdata.com"

    # Must be greater than Bright Data's `/scrape` 60-second API cap.
    # @return [Integer] default socket read timeout in seconds
    DEFAULT_TIMEOUT = 90

    # @param api_token [String] Bright Data API token
    # @param base_url [String] override for testing
    # @param open_timeout [Integer] TCP open timeout in seconds
    # @param read_timeout [Integer] socket read timeout in seconds
    # @param logger [Logger, nil] optional logger for debug request traces
    # @raise [BrightData::ConfigurationError] if `api_token` is nil or empty
    def initialize(api_token:, base_url: BASE_URL, open_timeout: 10, read_timeout: DEFAULT_TIMEOUT, logger: nil)
      raise ConfigurationError, "api_token is required" if api_token.nil? || api_token.empty?

      @api_token = api_token
      @base_url = base_url
      @open_timeout = open_timeout
      @read_timeout = read_timeout
      @logger = logger
    end

    # POST a JSON body.
    #
    # @param path [String] API path
    # @param query [Hash] query string params
    # @param body [Hash, nil] JSON body to encode
    # @return [Hash, Array, nil] parsed JSON body
    # @raise [BrightData::AuthError, BrightData::RateLimitError, BrightData::ServerError, BrightData::HTTPError]
    def post(path:, query: {}, body: nil)
      request(method: :post, path:, query:, body:)
    end

    # GET a path.
    #
    # @param path [String] API path
    # @param query [Hash] query string params
    # @return [Hash, Array, nil] parsed JSON body
    # @raise [BrightData::AuthError, BrightData::RateLimitError, BrightData::ServerError, BrightData::HTTPError]
    def get(path:, query: {})
      request(method: :get, path:, query:)
    end

    private

    def request(method:, path:, query: {}, body: nil)
      uri = build_uri(path:, query:)
      trace = LiveTrace.for(LiveTrace::Request.new(method:, path:, query:, body:, uri:))

      response, duration = timed_perform(uri:, req: build_request(method:, uri:, body:))
      trace.record_response(response:, duration:)

      log_request(method:, path:, status: response.code.to_i, duration:)

      handle_response(response)
    rescue StandardError => e
      trace&.record_error(e)
      raise
    end

    def timed_perform(uri:, req:)
      started = Process.clock_gettime(Process::CLOCK_MONOTONIC)

      response = perform(uri:, req:)

      [response, Process.clock_gettime(Process::CLOCK_MONOTONIC) - started]
    end

    def build_uri(path:, query:)
      uri = URI.parse("#{@base_url}#{path}")
      uri.query = URI.encode_www_form(query) unless query.empty?

      uri
    end

    def build_request(method:, uri:, body:)
      klass = if method == :post
                Net::HTTP::Post
              else
                Net::HTTP::Get
              end
      req = klass.new(uri)

      apply_headers(req)
      req.body = JSON.generate(body) if body

      req
    end

    def apply_headers(req)
      req["Authorization"] = "Bearer #{@api_token}"
      req["Content-Type"] = "application/json"
      req["Accept"] = "application/json"
    end

    def perform(uri:, req:) # rubocop:disable Metrics/MethodLength -- This is a simple method, the lines are from the Net::HTTP params
      Net::HTTP.start(
        uri.host,
        uri.port,
        use_ssl: uri.scheme == "https",
        open_timeout: @open_timeout,
        read_timeout: @read_timeout
      ) do |http|
        http.request(req)
      end
    rescue Net::OpenTimeout, Net::ReadTimeout => e
      raise HTTPError.new("Timeout: #{e.message}", status: nil, body: nil)
    rescue SocketError, SystemCallError, OpenSSL::SSL::SSLError, IOError => e
      raise HTTPError.new("Connection failed: #{e.message}", status: nil, body: nil)
    end

    def handle_response(response)
      status = response.code.to_i
      return parse_body(response) if (200..299).cover?(status)

      raise error_for(response, status)
    end

    # Factory mapping an error status to its exception. A dispatch at one level
    # of abstraction, so it stays a single `case`.
    def error_for(response, status) # rubocop:disable Metrics/MethodLength -- A case should be together all the time
      body = response.body.to_s
      case status
      when 401, 403
        AuthError.new("Bright Data API rejected the token (status #{status}): #{body}")
      when 429
        RateLimitError.new(
          "Bright Data rate limit hit (status 429)",
          status:,
          body:,
          response:,
          retry_after: parse_retry_after(response)
        )
      when 500..599
        ServerError.new("Bright Data server error (status #{status})", status:, body:, response:)
      else
        HTTPError.new("Unexpected HTTP status #{status}", status:, body:, response:)
      end
    end

    def parse_body(response)
      text = response.body.to_s
      return nil if text.empty?

      JSON.parse(text, symbolize_names: true)
    rescue JSON::ParserError => e
      return parse_json_lines(text, response:) if json_lines?(text, response:)

      raise HTTPError.new("Invalid JSON response: #{e.message}", status: response.code.to_i, body: text, response:)
    end

    def json_lines?(text, response:)
      response["content-type"].to_s.include?("jsonl") || text.lines.count > 1
    end

    def parse_json_lines(text, response:)
      text.each_line.filter_map do |line|
        stripped = line.strip
        next if stripped.empty?

        JSON.parse(stripped, symbolize_names: true)
      end
    rescue JSON::ParserError => e
      raise HTTPError.new("Invalid JSONL response: #{e.message}", status: response.code.to_i, body: text, response:)
    end

    def parse_retry_after(response)
      raw = response["retry-after"] || response["Retry-After"]
      Integer(raw, 10) if raw&.match?(/\A\d+\z/)
    end

    def log_request(method:, path:, status:, duration:)
      return unless @logger

      @logger.debug do
        format("[brightdata] %<method>s %<path>s -> %<status>d in %<duration>.3fs",
               method: method.upcase, path:, status:, duration:)
      end
    end
  end
end
