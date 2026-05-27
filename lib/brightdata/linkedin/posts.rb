# frozen_string_literal: true

module BrightData
  module LinkedIn
    # `client.linkedin.posts` endpoint family for LinkedIn posts.
    class Posts
      # @return [BrightData::LinkedIn::Posts::CollectByUrl]
      attr_reader :collect_by_url

      # @return [BrightData::LinkedIn::Posts::DiscoverByProfileUrl]
      attr_reader :discover_by_profile_url

      # @return [BrightData::LinkedIn::Posts::DiscoverByUrl]
      attr_reader :discover_by_url

      # @return [BrightData::LinkedIn::Posts::DiscoverByCompanyUrl]
      attr_reader :discover_by_company_url

      # @param http [BrightData::HTTP] shared HTTP wrapper
      def initialize(http:)
        @collect_by_url = CollectByUrl.new(http:)
        @discover_by_profile_url = DiscoverByProfileUrl.new(http:)
        @discover_by_url = DiscoverByUrl.new(http:)
        @discover_by_company_url = DiscoverByCompanyUrl.new(http:)
      end

      # @return [String] developer-friendly mode summary
      def inspect
        modes = %i[collect_by_url discover_by_profile_url discover_by_url discover_by_company_url]
        "#<BrightData::LinkedIn::Posts modes=#{modes}>"
      end

      # Posts collect-by-URL mode.
      #
      # @example
      #   posts = client.linkedin.posts.collect_by_url.scrape(urls: ["https://www.linkedin.com/posts/example"])
      class CollectByUrl
        include Endpoint

        endpoint(
          dataset_key: :posts_collect_by_url,
          input: Types::PostUrlInput,
          result: Types::Post,
          param: :urls
        )
      end

      # Posts discover-by-profile-URL mode.
      #
      # @example
      #   posts = client.linkedin.posts.discover_by_profile_url.scrape(profile_urls: ["https://www.linkedin.com/in/example/"])
      class DiscoverByProfileUrl
        include Endpoint

        endpoint(
          dataset_key: :posts_discover_by_profile_url,
          input: Types::PostProfileUrlInput,
          result: Types::Post,
          param: :profile_urls,
          extra_query: { type: "discover_new", discover_by: "profile_url" }
        )
      end

      # Posts discover-by-URL mode.
      #
      # @example
      #   posts = client.linkedin.posts.discover_by_url.scrape(urls: ["https://www.linkedin.com/feed/"])
      class DiscoverByUrl
        include Endpoint

        endpoint(
          dataset_key: :posts_discover_by_url,
          input: Types::PostUrlInput,
          result: Types::Post,
          param: :urls,
          extra_query: { type: "discover_new", discover_by: "url" }
        )
      end

      # Posts discover-by-company-URL mode.
      #
      # @example
      #   posts = client.linkedin.posts.discover_by_company_url.scrape(company_urls: ["https://www.linkedin.com/company/example/"])
      class DiscoverByCompanyUrl
        include Endpoint

        endpoint(
          dataset_key: :posts_discover_by_company_url,
          input: Types::PostCompanyUrlInput,
          result: Types::Post,
          param: :company_urls,
          extra_query: { type: "discover_new", discover_by: "company_url" }
        )
      end
    end
  end
end
