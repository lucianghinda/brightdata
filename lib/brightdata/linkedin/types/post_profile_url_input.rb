# frozen_string_literal: true

module BrightData
  module LinkedIn
    module Types
      # Input shape for LinkedIn post discovery by profile URL.
      #
      # @!attribute [r] url
      #   @return [String] LinkedIn profile URL
      PostProfileUrlInput = Data.define(:url)
    end
  end
end
