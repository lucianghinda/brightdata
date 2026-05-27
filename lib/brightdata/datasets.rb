# frozen_string_literal: true

module BrightData
  # Registry of Bright Data dataset IDs keyed by symbolic endpoint name.
  module Datasets
    # @return [Hash{Symbol=>String}] LinkedIn dataset IDs
    LINKEDIN = { # rubocop:disable Style/MutableConstant -- intentionally mutable so callers can register or override dataset IDs
      profiles_collect_by_url: "gd_l1viktl72bvl7bjuj0",
      companies_collect_by_url: "gd_l1vikfnt1wgvvqz95w",
      jobs_collect_by_url: "gd_lpfll7v5hcqtkxl6l",
      jobs_discover_by_url: "gd_lpfll7v5hcqtkxl6l",
      jobs_discover_by_keyword: "gd_lpfll7v5hcqtkxl6l",
      posts_collect_by_url: "gd_lyy3tktm25m4avu764",
      posts_discover_by_profile_url: "gd_lyy3tktm25m4avu764",
      posts_discover_by_url: "gd_lyy3tktm25m4avu764",
      posts_discover_by_company_url: "gd_lyy3tktm25m4avu764",
      people_discover_new_profiles: "gd_m8d03he47z8nwb5xc"
    }

    # Fetch a LinkedIn dataset ID.
    #
    # @param key [Symbol] symbolic endpoint name
    # @return [String] dataset ID
    # @raise [BrightData::ArgumentError] if key is unknown
    def self.id_for(key)
      LINKEDIN.fetch(key) do
        raise ::BrightData::ArgumentError, "Unknown LinkedIn dataset key: #{key.inspect}"
      end
    end
  end
end
