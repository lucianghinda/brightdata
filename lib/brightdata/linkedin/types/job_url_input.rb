# frozen_string_literal: true

module BrightData
  module LinkedIn
    module Types
      # Input shape for LinkedIn job URL modes.
      #
      # @!attribute [r] url
      #   @return [String] LinkedIn job URL
      JobUrlInput = Data.define(:url)
    end
  end
end
