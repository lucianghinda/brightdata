# Class BrightData::HTTPError <a id="class-BrightData-HTTPError"></a>

**Inherits:** `BrightData::Error`

Base class for transport-level errors.

## Attributes
### `body` [R] <a id="attribute-i-body"></a> <a id="body-instance_method"></a>
- **@return** [String, nil] raw response body

### `response` [R] <a id="attribute-i-response"></a> <a id="response-instance_method"></a>
- **@return** [Net::HTTPResponse, nil] raw Net::HTTP response

### `status` [R] <a id="attribute-i-status"></a> <a id="status-instance_method"></a>
- **@return** [Integer, nil] HTTP status, or nil if the request never completed

## Public Instance Methods
### `initialize(message, status: = nil, body: = nil, response: = nil)` <a id="method-i-initialize"></a> <a id="initialize-instance_method"></a>
- **@param** `message` [String] human-readable error message
- **@param** `status` [Integer, nil] HTTP status, or nil if unavailable
- **@param** `body` [String, nil] raw response body
- **@param** `response` [Net::HTTPResponse, nil] raw Net::HTTP response
- **@return** [HTTPError] a new instance of HTTPError
