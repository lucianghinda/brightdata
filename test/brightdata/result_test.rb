# frozen_string_literal: true

require "test_helper"

module BrightData
  class ResultTest < Minitest::Test
    def test_success_returns_success_result
      assert BrightData::Result.success(:ok).success?
    end

    def test_failure_returns_failure_result
      assert BrightData::Result.failure(:nope).failure?
    end

    def test_result_reexports_simple_result
      assert_equal SimpleResult, BrightData::Result
    end
  end
end
