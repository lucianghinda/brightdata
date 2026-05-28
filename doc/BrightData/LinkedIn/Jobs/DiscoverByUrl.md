# Class BrightData::LinkedIn::Jobs::DiscoverByUrl <a id="class-BrightData-LinkedIn-Jobs-DiscoverByUrl"></a>

**Inherits:** `Object`
**Includes:** `BrightData::LinkedIn::Endpoint`

Jobs discover-by-URL mode.

**@example**
```ruby
jobs = client.linkedin.jobs.discover_by_url.scrape(urls: ["https://www.linkedin.com/jobs/search/?keywords=ruby"])
```
