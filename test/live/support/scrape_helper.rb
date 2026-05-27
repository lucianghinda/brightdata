# frozen_string_literal: true

require "fileutils"
require "json"

module LiveScrapeHelper
  WAIT_TIMEOUT = 600
  WAIT_POLL_INTERVAL = 10
  LIVE_OUTPUT_DIR = File.expand_path("../../../tmp/live", __dir__)

  def live_results(name:, scrape:, trigger:)
    FileUtils.mkdir_p(LIVE_OUTPUT_DIR)
    live_log(name, "output_dir=#{LIVE_OUTPUT_DIR}")
    live_log(name, "scrape: start")
    result = scrape.call
    live_log(name, "scrape: returned #{result.class}")
    save_live_json(name, "scrape", result)
    return result if result.is_a?(Array)

    flunk "Expected live result array, got #{result.class}"
  rescue BrightData::ScrapeTimeoutError => e
    live_log(name, "scrape: timed out with snapshot #{e.snapshot_id}; waiting for returned snapshot")
    wait_for_live_snapshot(name:, snapshot: e.snapshot || trigger.call)
  rescue BrightData::HTTPError => e
    live_log(name, "scrape: HTTP error #{e.class} status=#{e.status.inspect} body=#{e.body.inspect}")
    return wait_for_live_snapshot(name:, snapshot: trigger.call) if e.status.nil?

    skip "Bright Data live API returned #{e.class}: #{e.message}; body=#{e.body.inspect}"
  end

  def assert_live_results_present!(name, results, strict: false)
    return unless results.empty?

    message = "Bright Data live endpoint #{name} returned no rows for the configured sample input"
    flunk message if strict

    skip message
  end

  private

  def wait_for_live_snapshot(name:, snapshot:)
    live_log(name, "trigger: snapshot_id=#{snapshot.id}")
    live_log(name, "wait: timeout=#{WAIT_TIMEOUT}s poll_interval=#{WAIT_POLL_INTERVAL}s")
    result = snapshot.wait(timeout: WAIT_TIMEOUT, poll_interval: WAIT_POLL_INTERVAL)
    live_log(name, "wait: success?=#{result.success?} failure?=#{result.failure?}")
    if result.success?
      save_live_json(name, "snapshot_results", result.payload)
      return result.payload
    end

    save_live_json(name, "snapshot_failure", result.error)
    flunk "Bright Data live snapshot failed: #{result.error.inspect}"
  rescue BrightData::ScrapeTimeoutError => e
    payload = {
      snapshot_id: e.snapshot_id,
      status: snapshot.status,
      timeout: WAIT_TIMEOUT,
      poll_interval: WAIT_POLL_INTERVAL,
      message: e.message
    }

    live_log(name, "wait: timed out snapshot_id=#{e.snapshot_id} status=#{snapshot.status}")
    save_live_json(name, "snapshot_timeout", payload)
    skip "Bright Data live snapshot #{e.snapshot_id} still #{snapshot.status.inspect} after #{WAIT_TIMEOUT}s"
  end

  def live_log(name, message)
    puts "[live:#{name}] #{message}"
  end

  def save_live_json(name, phase, payload)
    FileUtils.mkdir_p(LIVE_OUTPUT_DIR)
    path = File.join(LIVE_OUTPUT_DIR, "#{name}_#{phase}.json")
    File.write(path, JSON.pretty_generate(jsonable_payload(payload)))
    live_log(name, "saved #{phase} JSON to #{path}")
  end

  def jsonable_payload(payload)
    case payload
    when Array
      payload.map { |item| jsonable_payload(item) }
    when Hash
      payload.transform_values { |value| jsonable_payload(value) }
    else
      payload.respond_to?(:raw) ? payload.raw : payload
    end
  end
end
