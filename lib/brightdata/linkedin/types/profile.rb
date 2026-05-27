# frozen_string_literal: true

module BrightData
  module LinkedIn
    # Typed input and output value objects for LinkedIn endpoints.
    module Types
      # Typed representation of a LinkedIn profile response.
      #
      # @!attribute [r] id
      #   @return [String, nil] profile ID
      # @!attribute [r] name
      #   @return [String, nil] profile name
      # @!attribute [r] city
      #   @return [String, nil] profile city
      # @!attribute [r] country_code
      #   @return [String, nil] profile country code
      # @!attribute [r] position
      #   @return [String, nil] current position
      # @!attribute [r] about
      #   @return [String, nil] about text
      # @!attribute [r] current_company
      #   @return [Hash, nil] current company details
      # @!attribute [r] experience
      #   @return [Array<Hash>, nil] experience entries
      # @!attribute [r] education
      #   @return [Array<Hash>, nil] education entries
      # @!attribute [r] connections
      #   @return [Integer, String, nil] connection count
      # @!attribute [r] followers
      #   @return [Integer, String, nil] follower count
      # @!attribute [r] linkedin_id
      #   @return [String, nil] LinkedIn vanity ID
      # @!attribute [r] linkedin_num_id
      #   @return [String, Integer, nil] LinkedIn numeric ID
      # @!attribute [r] avatar
      #   @return [String, nil] avatar URL
      # @!attribute [r] banner_image
      #   @return [String, nil] banner image URL
      # @!attribute [r] people_also_viewed
      #   @return [Array<Hash>, nil] related profiles
      # @!attribute [r] input_url
      #   @return [String, nil] requested input URL
      # @!attribute [r] raw
      #   @return [Hash] full parsed API response
      # @note Use #raw to access fields not yet typed by this gem.
      Profile = Data.define(
        :id, :name, :city, :country_code, :position, :about,
        :current_company, :experience, :education, :connections, :followers,
        :linkedin_id, :linkedin_num_id, :avatar, :banner_image,
        :people_also_viewed, :input_url, :raw
      ) do
        # Build a profile from a symbol-keyed API response.
        #
        # @param hash [Hash] symbolized-key API response object
        # @return [BrightData::LinkedIn::Types::Profile]
        def self.from_api(hash) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength -- flat field-by-field mapping from the API response
          new(
            id: hash[:id],
            name: hash[:name],
            city: hash[:city],
            country_code: hash[:country_code],
            position: hash[:position],
            about: hash[:about],
            current_company: hash[:current_company],
            experience: hash[:experience],
            education: hash[:education],
            connections: hash[:connections],
            followers: hash[:followers],
            linkedin_id: hash[:linkedin_id],
            linkedin_num_id: hash[:linkedin_num_id],
            avatar: hash[:avatar],
            banner_image: hash[:banner_image],
            people_also_viewed: hash[:people_also_viewed],
            input_url: hash[:input_url],
            raw: hash
          )
        end
      end
    end
  end
end
