# Class BrightData::LinkedIn::Companies <a id="class-BrightData-LinkedIn-Companies"></a>

**Inherits:** `Object`
**Includes:** `BrightData::LinkedIn::Endpoint`

<code>client.linkedin.companies</code> endpoint family for LinkedIn companies
by URL.

**@example Trigger an async collection**
```ruby
snapshot = client.linkedin.companies.trigger(urls: ["https://www.linkedin.com/company/example/"])
```

**@example Scrape synchronously**
```ruby
companies = client.linkedin.companies.scrape(urls: ["https://www.linkedin.com/company/example/"])
```

## Public Instance Methods
### `scrape(urls:)` <a id="method-i-scrape"></a> <a id="scrape-instance_method"></a>
- **@param** `urls` [Array<String>] LinkedIn company URLs
- **@raise** [BrightData::ArgumentError] if `urls` is not an Array
- **@raise** [BrightData::ScrapeTimeoutError] when results exceed Bright Data's synchronous cap
- **@return** [Array<BrightData::LinkedIn::Types::Company>]

### `trigger(urls:)` <a id="method-i-trigger"></a> <a id="trigger-instance_method"></a>
- **@param** `urls` [Array<String>] LinkedIn company URLs
- **@raise** [BrightData::ArgumentError] if `urls` is not an Array
- **@return** [BrightData::Snapshot]
