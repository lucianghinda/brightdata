# Class BrightData::LiveTrace <a id="class-BrightData-LiveTrace"></a>

**Inherits:** `Object`

Optional request/response recorder, enabled by the `BRIGHTDATA_LIVE` env var.
Writes one JSON file per request, response, and error under
<code>tmp/live</code> so live API calls can be inspected after the fact.

{HTTP} asks for a recorder via {.for}; when tracing is disabled it gets a
{Null} recorder whose methods are no-ops, keeping the HTTP request path free
of conditionals.

- **@api** private

## Public Class Methods
### `for(request)` <a id="method-c-for"></a> <a id="for-class_method"></a>
Build a recorder and persist the request, or return a no-op recorder when
`BRIGHTDATA_LIVE` is unset.
- **@api** private
- **@param** `request` [LiveTrace::Request] the request to trace
- **@return** [LiveTrace, LiveTrace::Null]

## Public Instance Methods
### `initialize(request)` <a id="method-i-initialize"></a> <a id="initialize-instance_method"></a>
- **@api** private
- **@return** [LiveTrace] a new instance of LiveTrace

### `record_error(error)` <a id="method-i-record_error"></a> <a id="record_error-instance_method"></a>
- **@api** private

### `record_request()` <a id="method-i-record_request"></a> <a id="record_request-instance_method"></a>
- **@api** private

### `record_response(response:, duration:)` <a id="method-i-record_response"></a> <a id="record_response-instance_method"></a>
- **@api** private
