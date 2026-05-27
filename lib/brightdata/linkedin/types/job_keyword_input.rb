# frozen_string_literal: true

module BrightData
  module LinkedIn
    module Types
      # Input shape for `linkedin.jobs.discover_by_keyword`.
      #
      # @!attribute [r] location
      #   @return [String] target location
      # @!attribute [r] keyword
      #   @return [String, nil] job keyword
      # @!attribute [r] country
      #   @return [String, nil] country code
      # @!attribute [r] time_range
      #   @return [String, nil] posting time range
      # @!attribute [r] job_type
      #   @return [String, nil] job type
      # @!attribute [r] experience_level
      #   @return [String, nil] experience level
      # @!attribute [r] remote
      #   @return [String, Boolean, nil] remote filter
      # @!attribute [r] company
      #   @return [String, nil] company filter
      # @!attribute [r] selective_search
      #   @return [String, Boolean, nil] selective search flag
      # @!attribute [r] jobs_to_not_include
      #   @return [String, Array<String>, nil] excluded jobs
      # @!attribute [r] location_radius
      #   @return [Integer, String, nil] location radius
      JobKeywordInput = Data.define(
        :location, :keyword, :country, :time_range, :job_type,
        :experience_level, :remote, :company, :selective_search,
        :jobs_to_not_include, :location_radius
      ) do
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
