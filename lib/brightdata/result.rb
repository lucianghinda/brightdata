# frozen_string_literal: true

require "simple_result"

module BrightData
  # Result type re-exported from the `simple-result` gem.
  # @see https://rubygems.org/gems/simple-result
  Result = SimpleResult
end

##
# Compatibility constructors for the re-exported `simple-result` module.
module SimpleResult # rubocop:disable Style/OneClassPerFile -- the BrightData::Result alias and its constructors belong together
  # Build a successful result.
  # @param payload [Object, nil] success payload
  # @return [SimpleResult::Success]
  def self.success(payload = nil)
    Success.new(payload:)
  end

  # Build a failed result.
  # @param error [Object, nil] failure error
  # @return [SimpleResult::Failure]
  def self.failure(error = nil)
    Failure.new(error:)
  end
end
