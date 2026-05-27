# frozen_string_literal: true

module BrightData
  module LinkedIn
    # `client.linkedin.people` endpoint family for LinkedIn people discovery.
    class People
      # @return [BrightData::LinkedIn::People::DiscoverNewProfiles]
      attr_reader :discover_new_profiles

      # @param http [BrightData::HTTP] shared HTTP wrapper
      def initialize(http:)
        @discover_new_profiles = DiscoverNewProfiles.new(http:)
      end

      # @return [String] developer-friendly mode summary
      def inspect
        "#<BrightData::LinkedIn::People modes=[:discover_new_profiles]>"
      end

      # People discover-new-profiles mode.
      #
      # @example
      #   query = BrightData::LinkedIn::Types::PeopleDiscoverInput.new(
      #     url: "https://www.linkedin.com", first_name: "Jane", last_name: "Smith"
      #   )
      #   profiles = client.linkedin.people.discover_new_profiles.scrape(queries: [query])
      class DiscoverNewProfiles
        include Endpoint

        endpoint(
          dataset_key: :people_discover_new_profiles,
          input_type: Types::PeopleDiscoverInput,
          result: Types::DiscoveredProfile,
          param: :queries
        )
      end
    end
  end
end
