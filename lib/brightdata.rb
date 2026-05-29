# frozen_string_literal: true

require "zeitwerk"

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect("brightdata" => "BrightData", "http" => "HTTP", "linkedin" => "LinkedIn")
# Foundational files that don't follow Zeitwerk's one-file-one-constant rule
# are required eagerly below instead of autoloaded: version.rb defines VERSION
# (not Version), errors.rb groups the whole error hierarchy, and result.rb
# re-exports and reopens the external SimpleResult.
loader.ignore("#{__dir__}/brightdata/version.rb")
loader.ignore("#{__dir__}/brightdata/errors.rb")
loader.ignore("#{__dir__}/brightdata/result.rb")
loader.setup

require_relative "brightdata/version"
require_relative "brightdata/result"
require_relative "brightdata/errors"

# A small, ergonomic Ruby client for Bright Data's Datasets v3 scraper APIs.
#
# Create a {Client} with an API token, then reach endpoints through namespaces
# such as `client.linkedin`. Every endpoint exposes two methods:
#
# - `#scrape(...)` runs synchronously and returns parsed value-object results.
#   Bright Data caps synchronous scrapes at 60 seconds; if a job exceeds that,
#   it raises {ScrapeTimeoutError}, which carries a resumable {Snapshot}.
# - `#trigger(...)` starts an asynchronous collection and returns a {Snapshot}
#   you poll with `#wait`.
#
# Results are immutable `Data` value objects exposing named readers plus `#raw`,
# the full parsed response hash. The readers are not type-checked - `Data.define`
# gives shape, not static types. All errors inherit from {Error}.
#
# @example Synchronous scrape
#   client = BrightData::Client.new(api_token: ENV.fetch("BRIGHTDATA_API_TOKEN"))
#   profiles = client.linkedin.profiles.scrape(urls: ["https://www.linkedin.com/in/example/"])
#   profiles.first.name #=> "Example Person"
#
# @example Asynchronous trigger and poll
#   snapshot = client.linkedin.profiles.trigger(urls: ["https://www.linkedin.com/in/example/"])
#   result = snapshot.wait
#   result.payload if result.success?
#
# @example Discovery by keyword (nil fields are omitted from the request)
#   query = BrightData::LinkedIn::Types::JobKeywordInput.new(
#     location: "New York", keyword: "ruby",
#     country: nil, time_range: nil, job_type: nil, experience_level: nil,
#     remote: nil, company: nil, selective_search: nil,
#     jobs_to_not_include: nil, location_radius: nil
#   )
#   jobs = client.linkedin.jobs.discover_by_keyword.scrape(queries: [query])
#
# @example Recovering from a synchronous timeout
#   begin
#     client.linkedin.profiles.scrape(urls: urls)
#   rescue BrightData::ScrapeTimeoutError => e
#     e.snapshot.wait # fall back to async polling
#   end
module BrightData
end
