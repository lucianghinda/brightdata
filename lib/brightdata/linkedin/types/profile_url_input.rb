# frozen_string_literal: true

module BrightData
  module LinkedIn
    # Typed input and output value objects for LinkedIn endpoints.
    module Types
      # Input shape for `linkedin.profiles.{trigger,scrape}`.
      #
      # @!attribute [r] url
      #   @return [String] LinkedIn profile URL
      ProfileUrlInput = Data.define(:url)
    end
  end
end
