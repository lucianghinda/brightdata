# frozen_string_literal: true

require "test_helper"

module BrightData
  class HTTPTest < Minitest::Test
    BASE_URL = "https://api.brightdata.com"

    def test_post_returns_parsed_hash_for_json_object_body
      stub_request(:post, "#{BASE_URL}/ok").to_return_json(body: { ok: true })

      assert_equal({ ok: true }, http.post(path: "/ok", body: { input: [] }))
    end

    def test_get_returns_nil_for_empty_body
      stub_request(:get, "#{BASE_URL}/empty").to_return(status: 204, body: "")

      assert_nil http.get(path: "/empty")
    end

    def test_get_returns_parsed_array_for_json_array_body
      stub_request(:get, "#{BASE_URL}/items").to_return_json(body: [{ id: 1 }])

      assert_equal([{ id: 1 }], http.get(path: "/items"))
    end

    def test_get_returns_parsed_array_for_jsonl_body
      body = [
        JSON.generate({ id: 1, name: "one" }),
        JSON.generate({ id: 2, name: "two" })
      ].join("\n")
      stub_request(:get, "#{BASE_URL}/items.jsonl").to_return(status: 200, body:,
                                                              headers: { "Content-Type" => "application/jsonl" })

      assert_equal([{ id: 1, name: "one" }, { id: 2, name: "two" }], http.get(path: "/items.jsonl"))
    end

    def test_malformed_success_body_raises_http_error
      stub_request(:get, "#{BASE_URL}/broken-json").to_return(status: 200, body: "{",
                                                              headers: { "Content-Type" => "application/json" })

      error = assert_raises(HTTPError) { http.get(path: "/broken-json") }
      assert_equal 200, error.status
    end

    def test_query_params_are_encoded_in_url
      stub_request(:get,
                   "#{BASE_URL}/search").with(query: { q: "ruby api", limit: "2" }).to_return_json(body: { ok: true })

      http.get(path: "/search", query: { q: "ruby api", limit: 2 })

      assert_requested :get, "#{BASE_URL}/search", query: { q: "ruby api", limit: "2" }
    end

    def test_authorization_header_is_bearer_token
      stub_request(:post,
                   "#{BASE_URL}/auth").with(headers: { "Authorization" => "Bearer token" }).to_return_json(body: { ok: true })

      http.post(path: "/auth", body: {})

      assert_requested :post, "#{BASE_URL}/auth", headers: { "Authorization" => "Bearer token" }
    end

    def test_unauthorized_response_raises_auth_error
      stub_request(:get, "#{BASE_URL}/auth").to_return(status: 401, body: fixture("auth_error.json"))

      assert_raises(AuthError) { http.get(path: "/auth") }
    end

    def test_forbidden_response_raises_auth_error
      stub_request(:get, "#{BASE_URL}/forbidden").to_return(status: 403, body: fixture("auth_error.json"))

      assert_raises(AuthError) { http.get(path: "/forbidden") }
    end

    def test_rate_limit_response_raises_with_retry_after
      stub_request(:get, "#{BASE_URL}/limited").to_return(status: 429, body: fixture("rate_limit_response.json"),
                                                          headers: { "Retry-After" => "30" })

      error = assert_raises(RateLimitError) { http.get(path: "/limited") }
      assert_equal [429, 30], [error.status, error.retry_after]
    end

    def test_rate_limit_response_raises_with_nil_retry_after_when_header_absent
      stub_request(:get, "#{BASE_URL}/limited").to_return(status: 429, body: fixture("rate_limit_response.json"))

      assert_nil assert_raises(RateLimitError) { http.get(path: "/limited") }.retry_after
    end

    def test_internal_server_error_raises_server_error
      stub_request(:get, "#{BASE_URL}/server").to_return(status: 500, body: "broken")

      assert_raises(ServerError) { http.get(path: "/server") }
    end

    def test_bad_gateway_raises_server_error
      stub_request(:get, "#{BASE_URL}/bad-gateway").to_return(status: 502, body: "broken")

      assert_raises(ServerError) { http.get(path: "/bad-gateway") }
    end

    def test_unexpected_status_raises_http_error
      stub_request(:get, "#{BASE_URL}/unexpected").to_return(status: 418, body: "teapot")

      error = assert_raises(HTTPError) { http.get(path: "/unexpected") }
      assert_equal [418, "teapot"], [error.status, error.body]
    end

    def test_read_timeout_raises_http_error_with_nil_status
      Net::HTTP.stub(:start, ->(*) { raise Net::ReadTimeout, "execution expired" }) do
        error = assert_raises(HTTPError) { http.get(path: "/timeout") }
        assert_nil error.status
      end
    end

    def test_dns_failure_raises_http_error_with_nil_status
      Net::HTTP.stub(:start, ->(*) { raise SocketError, "getaddrinfo: nodename nor servname provided" }) do
        error = assert_raises(HTTPError) { http.get(path: "/dns") }
        assert_nil error.status
      end
    end

    def test_connection_refused_raises_http_error_with_nil_status
      Net::HTTP.stub(:start, ->(*) { raise Errno::ECONNREFUSED }) do
        error = assert_raises(HTTPError) { http.get(path: "/refused") }
        assert_nil error.status
      end
    end

    def test_ssl_failure_raises_http_error_with_nil_status
      Net::HTTP.stub(:start, ->(*) { raise OpenSSL::SSL::SSLError, "certificate verify failed" }) do
        error = assert_raises(HTTPError) { http.get(path: "/ssl") }
        assert_nil error.status
      end
    end

    def test_nil_api_token_raises_configuration_error
      assert_raises(ConfigurationError) { HTTP.new(api_token: nil) }
    end

    def test_empty_api_token_raises_configuration_error
      assert_raises(ConfigurationError) { HTTP.new(api_token: "") }
    end

    def test_logger_receives_debug_call_with_request_summary
      logger = CapturingLogger.new
      stub_request(:get, "#{BASE_URL}/logged").to_return_json(body: { ok: true })

      HTTP.new(api_token: "token", logger:).get(path: "/logged")

      assert_match(%r{\[brightdata\] GET /logged -> 200 in \d+\.\d{3}s}, logger.messages.first)
    end

    private

    def http
      HTTP.new(api_token: "token")
    end

    def fixture(name)
      File.read(File.expand_path("../fixtures/#{name}", __dir__))
    end

    class CapturingLogger
      attr_reader :messages

      def initialize
        @messages = []
      end

      def debug
        @messages << yield
      end
    end
  end
end
