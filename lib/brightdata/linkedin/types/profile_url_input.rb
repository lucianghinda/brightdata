# frozen_string_literal: true

module BrightData
  module LinkedIn
    # Input and output value objects for LinkedIn endpoints. Each class is an
    # immutable `Data` struct with named readers; values are not type-checked.
    module Types
      # Input shape for `linkedin.profiles.{trigger,scrape}`.
      #
      # @!attribute [r] url
      #   @return [String] LinkedIn profile URL
      ProfileUrlInput = Data.define(:url)
    end
  end
end
