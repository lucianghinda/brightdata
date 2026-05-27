# frozen_string_literal: true

module BrightData
  module LinkedIn
    # `client.linkedin.jobs` endpoint family for LinkedIn jobs.
    class Jobs
      # @return [BrightData::LinkedIn::Jobs::CollectByUrl]
      attr_reader :collect_by_url

      # @return [BrightData::LinkedIn::Jobs::DiscoverByUrl]
      attr_reader :discover_by_url

      # @return [BrightData::LinkedIn::Jobs::DiscoverByKeyword]
      attr_reader :discover_by_keyword

      # @param http [BrightData::HTTP] shared HTTP wrapper
      def initialize(http:)
        @collect_by_url = CollectByUrl.new(http:)
        @discover_by_url = DiscoverByUrl.new(http:)
        @discover_by_keyword = DiscoverByKeyword.new(http:)
      end

      # @return [String] developer-friendly mode summary
      def inspect
        "#<BrightData::LinkedIn::Jobs modes=[:collect_by_url, :discover_by_url, :discover_by_keyword]>"
      end

      # Jobs collect-by-URL mode.
      #
      # @example
      #   jobs = client.linkedin.jobs.collect_by_url.scrape(urls: ["https://www.linkedin.com/jobs/view/123/"])
      class CollectByUrl
        include Endpoint

        endpoint(
          dataset_key: :jobs_collect_by_url,
          input: Types::JobUrlInput,
          result: Types::Job,
          param: :urls
        )
      end

      # Jobs discover-by-URL mode.
      #
      # @example
      #   jobs = client.linkedin.jobs.discover_by_url.scrape(urls: ["https://www.linkedin.com/jobs/search/?keywords=ruby"])
      class DiscoverByUrl
        include Endpoint

        endpoint(
          dataset_key: :jobs_discover_by_url,
          input: Types::JobUrlInput,
          result: Types::Job,
          param: :urls,
          extra_query: { type: "discover_new", discover_by: "url" }
        )
      end

      # Jobs discover-by-keyword mode.
      #
      # @example
      #   query = BrightData::LinkedIn::Types::JobKeywordInput.new(
      #     location: "New York",
      #     keyword: "ruby",
      #     country: nil, time_range: nil, job_type: nil, experience_level: nil,
      #     remote: nil, company: nil, selective_search: nil,
      #     jobs_to_not_include: nil, location_radius: nil
      #   )
      #   jobs = client.linkedin.jobs.discover_by_keyword.scrape(queries: [query])
      class DiscoverByKeyword
        include Endpoint

        endpoint(
          dataset_key: :jobs_discover_by_keyword,
          input_type: Types::JobKeywordInput,
          result: Types::Job,
          param: :queries,
          extra_query: { type: "discover_new", discover_by: "keyword" }
        )
      end
    end
  end
end
