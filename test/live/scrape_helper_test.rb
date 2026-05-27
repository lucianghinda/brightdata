# frozen_string_literal: true

require "test_helper"

class LiveScrapeHelperTest < Minitest::Test
  include LiveScrapeHelper

  def test_live_snapshot_timeout_is_skipped
    snapshot = TimeoutSnapshot.new

    assert_raises(Minitest::Skip) do
      live_results(
        name: "timeout_test",
        scrape: -> { raise BrightData::ScrapeTimeoutError.new("scrape timeout", snapshot_id: snapshot.id, snapshot:) },
        trigger: -> { flunk "trigger should not be called when scrape timeout carries a snapshot" }
      )
    end
  ensure
    FileUtils.rm_f(File.join(LIVE_OUTPUT_DIR, "timeout_test_snapshot_timeout.json"))
  end

  class TimeoutSnapshot
    attr_reader :id, :status

    def initialize
      @id = "sd_timeout"
      @status = :running
    end

    def wait(timeout:, poll_interval:)
      raise BrightData::ScrapeTimeoutError.new(
        "Snapshot #{@id} still :#{@status} after #{timeout}s",
        snapshot_id: @id
      )
    end
  end
end
