# Class BrightData::RateLimitError <a id="class-BrightData-RateLimitError"></a>

**Inherits:** `BrightData::HTTPError`

Raised on 429 Too Many Requests responses.

## Attributes
### `retry_after` [R] <a id="attribute-i-retry_after"></a> <a id="retry_after-instance_method"></a>
- **@return** [Integer, nil] value of the `Retry-After` header in seconds, or nil if absent

## Public Instance Methods
### `initialize(message, status: = 429, body: = nil, response: = nil, retry_after: = nil)` <a id="method-i-initialize"></a> <a id="initialize-instance_method"></a>
- **@param** `message` [String] human-readable error message
- **@param** `status` [Integer] HTTP status
- **@param** `body` [String, nil] raw response body
- **@param** `response` [Net::HTTPResponse, nil] raw Net::HTTP response
- **@param** `retry_after` [Integer, nil] retry delay in seconds
- **@return** [RateLimitError] a new instance of RateLimitError
