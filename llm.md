# Module BrightData <a id="module-BrightData"></a>

A typed, ergonomic Ruby client for Bright Data's Datasets v3 scraper APIs.

Create a {Client} with an API token, then reach endpoints through namespaces
such as <code>client.linkedin</code>. Every endpoint exposes two methods:

*   `#scrape(...)` runs synchronously and returns parsed, typed results.
    Bright Data caps synchronous scrapes at 60 seconds; if a job exceeds that,
    it raises {ScrapeTimeoutError}, which carries a resumable {Snapshot}.
*   `#trigger(...)` starts an asynchronous collection and returns a {Snapshot}
    you poll with <code>#wait</code>.

Results are immutable `Data` value objects exposing typed readers plus
<code>#raw</code>, the full parsed response hash. All errors inherit from
{Error}.

**@example Synchronous scrape**
```ruby
client = BrightData::Client.new(api_token: ENV.fetch("BRIGHTDATA_API_TOKEN"))
profiles = client.linkedin.profiles.scrape(urls: ["https://www.linkedin.com/in/example/"])
profiles.first.name #=> "Example Person"
```

**@example Asynchronous trigger and poll**
```ruby
snapshot = client.linkedin.profiles.trigger(urls: ["https://www.linkedin.com/in/example/"])
result = snapshot.wait
result.payload if result.success?
```

**@example Discovery by keyword (nil fields are omitted from the request)**
```ruby
query = BrightData::LinkedIn::Types::JobKeywordInput.new(
  location: "New York", keyword: "ruby",
  country: nil, time_range: nil, job_type: nil, experience_level: nil,
  remote: nil, company: nil, selective_search: nil,
  jobs_to_not_include: nil, location_radius: nil
)
jobs = client.linkedin.jobs.discover_by_keyword.scrape(queries: [query])
```

**@example Recovering from a synchronous timeout**
```ruby
begin
  client.linkedin.profiles.scrape(urls: urls)
rescue BrightData::ScrapeTimeoutError => e
  e.snapshot.wait # fall back to async polling
end
```

## Constants
### `Result` <a id="constant-Result"></a> <a id="Result-constant"></a>
Result type re-exported from the <code>simple-result</code> gem.
- **@see** `https://rubygems.org/gems/simple-result`

### `VERSION` <a id="constant-VERSION"></a> <a id="VERSION-constant"></a>
Current gem version.

# Documentation

- [BrightData/ArgumentError.md](doc/BrightData/ArgumentError.md)
- [BrightData/AuthError.md](doc/BrightData/AuthError.md)
- [BrightData/Client.md](doc/BrightData/Client.md)
- [BrightData/ConfigurationError.md](doc/BrightData/ConfigurationError.md)
- [BrightData/Datasets.md](doc/BrightData/Datasets.md)
- [BrightData/Error.md](doc/BrightData/Error.md)
- [BrightData/HTTP.md](doc/BrightData/HTTP.md)
- [BrightData/HTTPError.md](doc/BrightData/HTTPError.md)
- [BrightData/LinkedIn/Companies.md](doc/BrightData/LinkedIn/Companies.md)
- [BrightData/LinkedIn/Endpoint/ClassMethods.md](doc/BrightData/LinkedIn/Endpoint/ClassMethods.md)
- [BrightData/LinkedIn/Endpoint.md](doc/BrightData/LinkedIn/Endpoint.md)
- [BrightData/LinkedIn/Jobs/CollectByUrl.md](doc/BrightData/LinkedIn/Jobs/CollectByUrl.md)
- [BrightData/LinkedIn/Jobs/DiscoverByKeyword.md](doc/BrightData/LinkedIn/Jobs/DiscoverByKeyword.md)
- [BrightData/LinkedIn/Jobs/DiscoverByUrl.md](doc/BrightData/LinkedIn/Jobs/DiscoverByUrl.md)
- [BrightData/LinkedIn/Jobs.md](doc/BrightData/LinkedIn/Jobs.md)
- [BrightData/LinkedIn/Namespace.md](doc/BrightData/LinkedIn/Namespace.md)
- [BrightData/LinkedIn/People/DiscoverNewProfiles.md](doc/BrightData/LinkedIn/People/DiscoverNewProfiles.md)
- [BrightData/LinkedIn/People.md](doc/BrightData/LinkedIn/People.md)
- [BrightData/LinkedIn/Posts/CollectByUrl.md](doc/BrightData/LinkedIn/Posts/CollectByUrl.md)
- [BrightData/LinkedIn/Posts/DiscoverByCompanyUrl.md](doc/BrightData/LinkedIn/Posts/DiscoverByCompanyUrl.md)
- [BrightData/LinkedIn/Posts/DiscoverByProfileUrl.md](doc/BrightData/LinkedIn/Posts/DiscoverByProfileUrl.md)
- [BrightData/LinkedIn/Posts/DiscoverByUrl.md](doc/BrightData/LinkedIn/Posts/DiscoverByUrl.md)
- [BrightData/LinkedIn/Posts.md](doc/BrightData/LinkedIn/Posts.md)
- [BrightData/LinkedIn/Profiles.md](doc/BrightData/LinkedIn/Profiles.md)
- [BrightData/LinkedIn/Types/Company.md](doc/BrightData/LinkedIn/Types/Company.md)
- [BrightData/LinkedIn/Types/CompanyUrlInput.md](doc/BrightData/LinkedIn/Types/CompanyUrlInput.md)
- [BrightData/LinkedIn/Types/DiscoveredProfile.md](doc/BrightData/LinkedIn/Types/DiscoveredProfile.md)
- [BrightData/LinkedIn/Types/Job.md](doc/BrightData/LinkedIn/Types/Job.md)
- [BrightData/LinkedIn/Types/JobKeywordInput.md](doc/BrightData/LinkedIn/Types/JobKeywordInput.md)
- [BrightData/LinkedIn/Types/JobUrlInput.md](doc/BrightData/LinkedIn/Types/JobUrlInput.md)
- [BrightData/LinkedIn/Types/PeopleDiscoverInput.md](doc/BrightData/LinkedIn/Types/PeopleDiscoverInput.md)
- [BrightData/LinkedIn/Types/Post.md](doc/BrightData/LinkedIn/Types/Post.md)
- [BrightData/LinkedIn/Types/PostCompanyUrlInput.md](doc/BrightData/LinkedIn/Types/PostCompanyUrlInput.md)
- [BrightData/LinkedIn/Types/PostProfileUrlInput.md](doc/BrightData/LinkedIn/Types/PostProfileUrlInput.md)
- [BrightData/LinkedIn/Types/PostUrlInput.md](doc/BrightData/LinkedIn/Types/PostUrlInput.md)
- [BrightData/LinkedIn/Types/Profile.md](doc/BrightData/LinkedIn/Types/Profile.md)
- [BrightData/LinkedIn/Types/ProfileUrlInput.md](doc/BrightData/LinkedIn/Types/ProfileUrlInput.md)
- [BrightData/LinkedIn/Types.md](doc/BrightData/LinkedIn/Types.md)
- [BrightData/LinkedIn.md](doc/BrightData/LinkedIn.md)
- [BrightData/LiveTrace/Null.md](doc/BrightData/LiveTrace/Null.md)
- [BrightData/LiveTrace/Request.md](doc/BrightData/LiveTrace/Request.md)
- [BrightData/LiveTrace.md](doc/BrightData/LiveTrace.md)
- [BrightData/RateLimitError.md](doc/BrightData/RateLimitError.md)
- [BrightData/ScrapeTimeoutError.md](doc/BrightData/ScrapeTimeoutError.md)
- [BrightData/ServerError.md](doc/BrightData/ServerError.md)
- [BrightData/Snapshot.md](doc/BrightData/Snapshot.md)
- [BrightData/SnapshotFailedError.md](doc/BrightData/SnapshotFailedError.md)
- [SimpleResult.md](doc/SimpleResult.md)
