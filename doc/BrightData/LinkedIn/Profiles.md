# Class BrightData::LinkedIn::Profiles <a id="class-BrightData-LinkedIn-Profiles"></a>

**Inherits:** `Object`
**Includes:** `BrightData::LinkedIn::Endpoint`

<code>client.linkedin.profiles</code> endpoint family for LinkedIn profiles by
URL.

**@example Trigger an async collection**
```ruby
snapshot = client.linkedin.profiles.trigger(urls: ["https://www.linkedin.com/in/example/"])
```

**@example Scrape synchronously**
```ruby
profiles = client.linkedin.profiles.scrape(urls: ["https://www.linkedin.com/in/example/"])
```

## Public Instance Methods
### `scrape(urls:)` <a id="method-i-scrape"></a> <a id="scrape-instance_method"></a>
- **@param** `urls` [Array<String>] LinkedIn profile URLs
- **@raise** [BrightData::ArgumentError] if `urls` is not an Array
- **@raise** [BrightData::ScrapeTimeoutError] when results exceed Bright Data's synchronous cap
- **@return** [Array<BrightData::LinkedIn::Types::Profile>]

### `trigger(urls:)` <a id="method-i-trigger"></a> <a id="trigger-instance_method"></a>
- **@param** `urls` [Array<String>] LinkedIn profile URLs
- **@raise** [BrightData::ArgumentError] if `urls` is not an Array
- **@return** [BrightData::Snapshot]
