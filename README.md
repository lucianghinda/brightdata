# brightdata

A typed, ergonomic Ruby client for [Bright Data](https://brightdata.com)'s
Datasets v3 scraper APIs. Version 0.1.0 ships the LinkedIn endpoints.

## Installation

Add it to your Gemfile:

```ruby
gem "brightdata"
```

Then run `bundle install`, or install it directly:

```sh
gem install brightdata
```

Requires Ruby 3.4.4 or newer.

## Configuration

Create a client with your Bright Data API token:

```ruby
client = BrightData::Client.new(api_token: ENV.fetch("BRIGHTDATA_API_TOKEN"))
```

Optional keyword arguments:

- `base_url:` — override the API host (defaults to `https://api.brightdata.com`).
- `logger:` — a `Logger` that receives one `debug` line per request.

## Synchronous vs. asynchronous

Every endpoint exposes two methods:

- `#scrape(...)` runs synchronously and returns parsed, typed results. Bright
  Data caps synchronous scrapes at 60 seconds; if a job exceeds that,
  `scrape` raises `BrightData::ScrapeTimeoutError`, which carries a resumable
  snapshot (`error.snapshot`).
- `#trigger(...)` starts an asynchronous collection and returns a
  `BrightData::Snapshot` you poll with `#wait`.

```ruby
# Synchronous
profiles = client.linkedin.profiles.scrape(
  urls: ["https://www.linkedin.com/in/example/"]
)
profiles.first.name # => "Example Person"

# Asynchronous
snapshot = client.linkedin.profiles.trigger(
  urls: ["https://www.linkedin.com/in/example/"]
)
result = snapshot.wait # blocks, polling progress until ready/failed/timeout
if result.success?
  result.payload # => Array<BrightData::LinkedIn::Types::Profile>
else
  result.error   # => raw failure payload from Bright Data
end
```

`Snapshot#wait` accepts `timeout:` (default 300s) and `poll_interval:`
(default 5s), and raises `BrightData::ScrapeTimeoutError` if the deadline
passes before the snapshot reaches a terminal state.

## LinkedIn endpoints

| Call | Argument | Returns |
| --- | --- | --- |
| `linkedin.profiles` | `urls:` | `Types::Profile` |
| `linkedin.companies` | `urls:` | `Types::Company` |
| `linkedin.jobs.collect_by_url` | `urls:` | `Types::Job` |
| `linkedin.jobs.discover_by_url` | `urls:` | `Types::Job` |
| `linkedin.jobs.discover_by_keyword` | `queries:` (`Types::JobKeywordInput`) | `Types::Job` |
| `linkedin.posts.collect_by_url` | `urls:` | `Types::Post` |
| `linkedin.posts.discover_by_url` | `urls:` | `Types::Post` |
| `linkedin.posts.discover_by_profile_url` | `profile_urls:` | `Types::Post` |
| `linkedin.posts.discover_by_company_url` | `company_urls:` | `Types::Post` |
| `linkedin.people.discover_new_profiles` | `queries:` (`Types::PeopleDiscoverInput`) | `Types::DiscoveredProfile` |

### Discovery by keyword

```ruby
query = BrightData::LinkedIn::Types::JobKeywordInput.new(
  location: "New York",
  keyword: "ruby",
  country: nil, time_range: nil, job_type: nil, experience_level: nil,
  remote: nil, company: nil, selective_search: nil,
  jobs_to_not_include: nil, location_radius: nil
)

jobs = client.linkedin.jobs.discover_by_keyword.scrape(queries: [query])
```

`nil` fields are omitted from the request payload.

## Result types

Results are immutable `Data` value objects (`Types::Profile`, `Types::Company`,
`Types::Job`, `Types::Post`, `Types::DiscoveredProfile`). Each exposes typed
readers for the common fields plus `#raw`, the full parsed response hash, so you
can reach fields the gem does not yet type:

```ruby
profile = profiles.first
profile.name        # typed reader
profile.raw[:posts] # anything not yet typed
```

## Error handling

All errors inherit from `BrightData::Error`:

- `BrightData::ConfigurationError` — blank API token.
- `BrightData::ArgumentError` — bad argument shape (note: not Ruby's
  `::ArgumentError`).
- `BrightData::AuthError` — 401/403 from the API.
- `BrightData::RateLimitError` — 429; exposes `#retry_after`.
- `BrightData::ServerError` — 5xx.
- `BrightData::HTTPError` — other transport failures and timeouts.
- `BrightData::ScrapeTimeoutError` — synchronous scrape exceeded the 60s cap;
  recover via `error.snapshot.wait`.

```ruby
begin
  client.linkedin.profiles.scrape(urls: urls)
rescue BrightData::ScrapeTimeoutError => e
  e.snapshot.wait # fall back to async polling
rescue BrightData::RateLimitError => e
  sleep(e.retry_after || 5)
  retry
rescue BrightData::Error => e
  warn "Bright Data request failed: #{e.message}"
end
```

## License

Released under the [MIT License](LICENSE.txt).
