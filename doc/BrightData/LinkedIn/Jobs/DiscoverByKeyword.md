# Class BrightData::LinkedIn::Jobs::DiscoverByKeyword <a id="class-BrightData-LinkedIn-Jobs-DiscoverByKeyword"></a>

**Inherits:** `Object`
**Includes:** `BrightData::LinkedIn::Endpoint`

Jobs discover-by-keyword mode.

**@example**
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
