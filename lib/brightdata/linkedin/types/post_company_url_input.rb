# frozen_string_literal: true

module BrightData
  module LinkedIn
    module Types
      # Input shape for LinkedIn post discovery by company URL.
      #
      # @!attribute [r] url
      #   @return [String] LinkedIn company URL
      PostCompanyUrlInput = Data.define(:url)
    end
  end
end
