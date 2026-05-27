# frozen_string_literal: true

require "test_helper"

module BrightData
  module LinkedIn
    class PostsCollectByUrlTest < Minitest::Test
      def test_scrape_returns_post_array_with_raw_payload
        stub_scrape

        post = collect_by_url.scrape(urls: [post_url]).first

        assert_equal ["Synthetic post fixture for mocked tests.", "kept in raw"],
                     [post.post_text, post.raw.fetch(:unexpected_field)]
      end

      def test_trigger_returns_snapshot
        stub_request(:post, "#{HTTP::BASE_URL}/datasets/v3/trigger")
          .with(query: { dataset_id: Datasets.id_for(:posts_collect_by_url) })
          .to_return_json(body: { snapshot_id: "s_posts" })

        snapshot = collect_by_url.trigger(urls: [post_url])

        assert_equal "s_posts", snapshot.id
      end

      def test_empty_urls_array_returns_empty_array
        assert_equal [], collect_by_url.scrape(urls: [])
      end

      def test_urls_must_be_an_array
        error = assert_raises(BrightData::ArgumentError) { collect_by_url.scrape(urls: post_url) }

        assert_match "urls: must be an Array", error.message
      end

      def test_request_url_contains_dataset_id
        stub_scrape

        collect_by_url.scrape(urls: [post_url])

        assert_requested :post, "#{HTTP::BASE_URL}/datasets/v3/scrape", query: { dataset_id: Datasets.id_for(:posts_collect_by_url) }
      end

      private

      def posts
        Client.new(api_token: "token").linkedin.posts
      end

      def collect_by_url
        posts.collect_by_url
      end

      def post_url
        "https://www.linkedin.com/posts/example"
      end

      def stub_scrape
        stub_request(:post, "#{HTTP::BASE_URL}/datasets/v3/scrape")
          .with(query: { dataset_id: Datasets.id_for(:posts_collect_by_url) })
          .to_return(status: 200, body: fixture("linkedin/posts_collect_by_url_response.json"), headers: { "Content-Type" => "application/json" })
      end

      def fixture(name)
        File.read(File.expand_path("../../fixtures/#{name}", __dir__))
      end
    end
  end
end
