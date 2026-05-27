# frozen_string_literal: true

module BrightData
  module LinkedIn
    module Types
      # Input shape for `linkedin.people.discover_new_profiles`.
      #
      # @!attribute [r] url
      #   @return [String] must be `https://www.linkedin.com`
      # @!attribute [r] first_name
      #   @return [String, nil] first name to search by
      # @!attribute [r] last_name
      #   @return [String, nil] last name to search by
      PeopleDiscoverInput = Data.define(:url, :first_name, :last_name) do
        # Serialize for Bright Data, omitting nil values.
        #
        # @return [Hash] API input payload
        def to_api_hash
          to_h.compact
        end
      end
    end
  end
end
