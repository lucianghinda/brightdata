# Class BrightData::LinkedIn::Jobs::CollectByUrl <a id="class-BrightData-LinkedIn-Jobs-CollectByUrl"></a>

**Inherits:** `Object`
**Includes:** `BrightData::LinkedIn::Endpoint`

Jobs collect-by-URL mode.

**@example**
```ruby
jobs = client.linkedin.jobs.collect_by_url.scrape(urls: ["https://www.linkedin.com/jobs/view/123/"])
```
