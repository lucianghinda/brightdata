# frozen_string_literal: true

module BrightData
  module LinkedIn
    module Types
      # Typed representation of a discovered LinkedIn profile response.
      #
      # @!attribute [r] url
      #   @return [String, nil] profile URL
      # @!attribute [r] name
      #   @return [String, nil] profile name
      # @!attribute [r] subtitle
      #   @return [String, nil] profile subtitle
      # @!attribute [r] location
      #   @return [String, nil] profile location
      # @!attribute [r] experience
      #   @return [String, Hash, Array, nil] experience summary
      # @!attribute [r] education
      #   @return [String, Hash, Array, nil] education summary
      # @!attribute [r] avatar
      #   @return [String, nil] avatar URL
      # @!attribute [r] raw
      #   @return [Hash] full parsed API response
      # @note Use #raw to access fields not yet typed by this gem.
      DiscoveredProfile = Data.define(:url, :name, :subtitle, :location, :experience, :education, :avatar, :raw) do
        # Build a discovered profile from a symbol-keyed API response.
        #
        # @param hash [Hash] symbolized-key API response object
        # @return [BrightData::LinkedIn::Types::DiscoveredProfile]
        def self.from_api(hash)
          new(
            url: hash[:url],
            name: hash[:name],
            subtitle: hash[:subtitle],
            location: hash[:location],
            experience: hash[:experience],
            education: hash[:education],
            avatar: hash[:avatar],
            raw: hash
          )
        end
      end
    end
  end
end
