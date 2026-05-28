# Class BrightData::Client <a id="class-BrightData-Client"></a>

**Inherits:** `Object`

Top-level Bright Data API client.

**@example**
```ruby
client = BrightData::Client.new(api_token: ENV.fetch("BRIGHTDATA_API_TOKEN"))
client.linkedin
```

## Attributes
### `http` [R] <a id="attribute-i-http"></a> <a id="http-instance_method"></a>
- **@return** [BrightData::HTTP] underlying HTTP wrapper

### `linkedin` [R] <a id="attribute-i-linkedin"></a> <a id="linkedin-instance_method"></a>
- **@return** [BrightData::LinkedIn::Namespace] LinkedIn endpoint namespace

## Public Instance Methods
### `initialize(api_token:, base_url: = BrightData::HTTP::BASE_URL, logger: = nil)` <a id="method-i-initialize"></a> <a id="initialize-instance_method"></a>
- **@param** `api_token` [String] Bright Data API token
- **@param** `base_url` [String] override Bright Data API base URL
- **@param** `logger` [Logger, nil] optional logger for request tracing
- **@raise** [BrightData::ConfigurationError] if `api_token` is nil or empty
- **@return** [Client] a new instance of Client
