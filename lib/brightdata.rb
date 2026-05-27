# frozen_string_literal: true

require "brightdata/version"
require "brightdata/result"
require "brightdata/errors"
require "brightdata/datasets"
require "brightdata/live_trace"
require "brightdata/http"
require "brightdata/snapshot"
require "brightdata/linkedin/endpoint"
require "brightdata/linkedin/types/profile_url_input"
require "brightdata/linkedin/types/profile"
require "brightdata/linkedin/profiles"
require "brightdata/linkedin/types/company_url_input"
require "brightdata/linkedin/types/company"
require "brightdata/linkedin/companies"
require "brightdata/linkedin/types/job_url_input"
require "brightdata/linkedin/types/job_keyword_input"
require "brightdata/linkedin/types/job"
require "brightdata/linkedin/jobs"
require "brightdata/linkedin/types/post_url_input"
require "brightdata/linkedin/types/post_profile_url_input"
require "brightdata/linkedin/types/post_company_url_input"
require "brightdata/linkedin/types/post"
require "brightdata/linkedin/posts"
require "brightdata/linkedin/types/people_discover_input"
require "brightdata/linkedin/types/discovered_profile"
require "brightdata/linkedin/people"
require "brightdata/linkedin/namespace"
require "brightdata/client"

# A typed, ergonomic Ruby client for Bright Data's Datasets v3 scraper APIs.
#
# Create a {Client} with an API token, then reach endpoints through namespaces
# such as `client.linkedin`. Every endpoint exposes two methods:
#
# - `#scrape(...)` runs synchronously and returns parsed, typed results. Bright
#   Data caps synchronous scrapes at 60 seconds; if a job exceeds that, it
#   raises {ScrapeTimeoutError}, which carries a resumable {Snapshot}.
# - `#trigger(...)` starts an asynchronous collection and returns a {Snapshot}
#   you poll with `#wait`.
#
# Results are immutable `Data` value objects exposing typed readers plus `#raw`,
# the full parsed response hash. All errors inherit from {Error}.
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
