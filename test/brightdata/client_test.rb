# frozen_string_literal: true

require "test_helper"

module BrightData
  class ClientTest < Minitest::Test
    def test_client_initializes_with_api_token
      assert_instance_of Client, Client.new(api_token: "token")
    end

    def test_client_requires_api_token_keyword
      assert_raises(::ArgumentError) { Client.new }
    end

    def test_nil_api_token_raises_configuration_error
      assert_raises(ConfigurationError) { Client.new(api_token: nil) }
    end

    def test_linkedin_returns_same_eager_namespace_object
      client = Client.new(api_token: "token")

      assert_same client.linkedin, client.linkedin
    end

    def test_http_is_accessible_for_snapshot_recovery
      assert_instance_of HTTP, Client.new(api_token: "token").http
    end

    def test_logger_is_passed_to_http
      logger = CapturingLogger.new
      client = Client.new(api_token: "token", logger:)
      stub_request(:get, "#{HTTP::BASE_URL}/logged").to_return_json(body: { ok: true })

      client.http.get(path: "/logged")

      assert_match(%r{\[brightdata\] GET /logged -> 200 in \d+\.\d{3}s}, logger.messages.first)
    end

    def test_linkedin_namespace_eagerly_initializes_endpoint_families
      linkedin = Client.new(api_token: "token").linkedin

      assert_equal [LinkedIn::Profiles, LinkedIn::Companies, LinkedIn::Jobs, LinkedIn::Posts, LinkedIn::People], [
        linkedin.profiles.class,
        linkedin.companies.class,
        linkedin.jobs.class,
        linkedin.posts.class,
        linkedin.people.class
      ]
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
