# frozen_string_literal: true

module BrightData
  module LinkedIn
    module Types
      # Input shape for `linkedin.companies.{trigger,scrape}`.
      #
      # @!attribute [r] url
      #   @return [String] LinkedIn company URL
      CompanyUrlInput = Data.define(:url)
    end
  end
end
