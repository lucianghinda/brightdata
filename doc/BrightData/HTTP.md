# Class BrightData::HTTP <a id="class-BrightData-HTTP"></a>

**Inherits:** `Object`

Thin Net::HTTP wrapper. Single point of egress for the gem.

Optional request tracing lives in {LiveTrace}, kept out of this class so the
request path stays a small, readable Net::HTTP shim.

## Constants
### `BASE_URL` <a id="constant-BASE_URL"></a> <a id="BASE_URL-constant"></a>
- **@return** [String] default Bright Data API base URL

### `DEFAULT_TIMEOUT` <a id="constant-DEFAULT_TIMEOUT"></a> <a id="DEFAULT_TIMEOUT-constant"></a>
Must be greater than Bright Data's <code>/scrape</code> 60-second API cap.
- **@return** [Integer] default socket read timeout in seconds

## Public Instance Methods
### `get(path:, query: = {})` <a id="method-i-get"></a> <a id="get-instance_method"></a>
GET a path.
- **@param** `path` [String] API path
- **@param** `query` [Hash] query string params
- **@raise** [BrightData::AuthError, BrightData::RateLimitError, BrightData::ServerError, BrightData::HTTPError]
- **@return** [Hash, Array, nil] parsed JSON body

### `initialize(api_token:, base_url: = BASE_URL, open_timeout: = 10, read_timeout: = DEFAULT_TIMEOUT, logger: = nil)` <a id="method-i-initialize"></a> <a id="initialize-instance_method"></a>
- **@param** `api_token` [String] Bright Data API token
- **@param** `base_url` [String] override for testing
- **@param** `open_timeout` [Integer] TCP open timeout in seconds
- **@param** `read_timeout` [Integer] socket read timeout in seconds
- **@param** `logger` [Logger, nil] optional logger for debug request traces
- **@raise** [BrightData::ConfigurationError] if `api_token` is nil or empty
- **@return** [HTTP] a new instance of HTTP

### `post(path:, query: = {}, body: = nil)` <a id="method-i-post"></a> <a id="post-instance_method"></a>
POST a JSON body.
- **@param** `path` [String] API path
- **@param** `query` [Hash] query string params
- **@param** `body` [Hash, nil] JSON body to encode
- **@raise** [BrightData::AuthError, BrightData::RateLimitError, BrightData::ServerError, BrightData::HTTPError]
- **@return** [Hash, Array, nil] parsed JSON body
