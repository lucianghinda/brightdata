# frozen_string_literal: true

module BrightData
  module LinkedIn
    # Accessor for the LinkedIn endpoint families.
    class Namespace
      # @return [BrightData::LinkedIn::Profiles]
      attr_reader :profiles

      # @return [BrightData::LinkedIn::Companies]
      attr_reader :companies

      # @return [BrightData::LinkedIn::Jobs]
      attr_reader :jobs

      # @return [BrightData::LinkedIn::Posts]
      attr_reader :posts

      # @return [BrightData::LinkedIn::People]
      attr_reader :people

      # @param http [BrightData::HTTP] shared HTTP wrapper
      def initialize(http:)
        @profiles = Profiles.new(http:)
        @companies = Companies.new(http:)
        @jobs = Jobs.new(http:)
        @posts = Posts.new(http:)
        @people = People.new(http:)
      end
    end
  end
end
