# frozen_string_literal: true

module BrightData
  module LinkedIn
    module Types
      # Typed representation of a LinkedIn company response.
      #
      # @!attribute [r] id
      #   @return [String, nil] company ID
      # @!attribute [r] name
      #   @return [String, nil] company name
      # @!attribute [r] country_code
      #   @return [String, nil] country code
      # @!attribute [r] locations
      #   @return [Array<Hash>, nil] company locations
      # @!attribute [r] followers
      #   @return [Integer, String, nil] follower count
      # @!attribute [r] employees_in_linkedin
      #   @return [Integer, String, nil] LinkedIn employee count
      # @!attribute [r] company_size
      #   @return [String, nil] company size
      # @!attribute [r] industries
      #   @return [Array<String>, nil] industries
      # @!attribute [r] specialties
      #   @return [Array<String>, nil] specialties
      # @!attribute [r] website
      #   @return [String, nil] company website
      # @!attribute [r] founded
      #   @return [String, Integer, nil] founded year
      # @!attribute [r] company_id
      #   @return [String, nil] LinkedIn company ID
      # @!attribute [r] employees
      #   @return [Array<Hash>, nil] employees
      # @!attribute [r] similar
      #   @return [Array<Hash>, nil] similar companies
      # @!attribute [r] updates
      #   @return [Array<Hash>, nil] updates
      # @!attribute [r] logo
      #   @return [String, nil] logo URL
      # @!attribute [r] image
      #   @return [String, nil] image URL
      # @!attribute [r] headquarters
      #   @return [Hash, nil] headquarters
      # @!attribute [r] funding
      #   @return [Hash, nil] funding details
      # @!attribute [r] investors
      #   @return [Array<Hash>, nil] investors
      # @!attribute [r] affiliated
      #   @return [Array<Hash>, nil] affiliated companies
      # @!attribute [r] raw
      #   @return [Hash] full parsed API response
      # @note Use #raw to access fields not yet typed by this gem.
      Company = Data.define(
        :id, :name, :country_code, :locations, :followers,
        :employees_in_linkedin, :company_size, :industries, :specialties,
        :website, :founded, :company_id, :employees, :similar, :updates,
        :logo, :image, :headquarters, :funding, :investors, :affiliated, :raw
      ) do
        # Build a company from a symbol-keyed API response.
        #
        # @param hash [Hash] symbolized-key API response object
        # @return [BrightData::LinkedIn::Types::Company]
        def self.from_api(hash) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength -- flat field-by-field mapping from the API response
          new(
            id: hash[:id],
            name: hash[:name],
            country_code: hash[:country_code],
            locations: hash[:locations],
            followers: hash[:followers],
            employees_in_linkedin: hash[:employees_in_linkedin],
            company_size: hash[:company_size],
            industries: hash[:industries],
            specialties: hash[:specialties],
            website: hash[:website],
            founded: hash[:founded],
            company_id: hash[:company_id],
            employees: hash[:employees],
            similar: hash[:similar],
            updates: hash[:updates],
            logo: hash[:logo],
            image: hash[:image],
            headquarters: hash[:headquarters],
            funding: hash[:funding],
            investors: hash[:investors],
            affiliated: hash[:affiliated],
            raw: hash
          )
        end
      end
    end
  end
end
