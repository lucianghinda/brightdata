# frozen_string_literal: true

require "test_helper"

module BrightData
  module LinkedIn
    class PostsDiscoverByProfileUrlTest < Minitest::Test
      def test_scrape_returns_post_array
        stub_scrape

        post = discover.scrape(profile_urls: [profile_url]).first

        assert_equal "Synthetic profile discovery post fixture.", post.post_text
      end

      def test_request_includes_discover_query_params
        stub_scrape

        discover.scrape(profile_urls: [profile_url])

        assert_requested :post, "#{HTTP::BASE_URL}/datasets/v3/scrape", query: expected_query
      end

      def test_trigger_returns_snapshot
        stub_request(:post, "#{HTTP::BASE_URL}/datasets/v3/trigger")
          .with(query: expected_query)
          .to_return_json(body: { snapshot_id: "s_posts_profile" })

        snapshot = discover.trigger(profile_urls: [profile_url])

        assert_equal "s_posts_profile", snapshot.id
      end

      def test_profile_urls_must_be_an_array
        error = assert_raises(BrightData::ArgumentError) { discover.scrape(profile_urls: profile_url) }

        assert_match "profile_urls: must be an Array", error.message
      end

      def test_wrong_kwarg_name_raises_native_argument_error
        assert_raises(::ArgumentError) { discover.scrape(urls: [profile_url]) }
      end

      private

      def discover
        Client.new(api_token: "token").linkedin.posts.discover_by_profile_url
      end

      def profile_url
        "https://www.linkedin.com/in/example/"
      end

      def expected_query
        { dataset_id: Datasets.id_for(:posts_discover_by_profile_url), type: "discover_new",
          discover_by: "profile_url" }
      end

      def stub_scrape
        stub_request(:post, "#{HTTP::BASE_URL}/datasets/v3/scrape")
          .with(query: expected_query)
          .to_return(status: 200, body: fixture("linkedin/posts_discover_by_profile_url_response.json"), headers: { "Content-Type" => "application/json" })
      end

      def fixture(name)
        File.read(File.expand_path("../../fixtures/#{name}", __dir__))
      end
    end
  end
end
