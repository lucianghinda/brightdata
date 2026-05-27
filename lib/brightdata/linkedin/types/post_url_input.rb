# frozen_string_literal: true

module BrightData
  module LinkedIn
    module Types
      # Input shape for LinkedIn post URL modes.
      #
      # @!attribute [r] url
      #   @return [String] LinkedIn post URL
      PostUrlInput = Data.define(:url)
    end
  end
end
