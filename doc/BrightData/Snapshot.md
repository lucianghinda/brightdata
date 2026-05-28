# Class BrightData::Snapshot <a id="class-BrightData-Snapshot"></a>

**Inherits:** `Object`

Represents a Bright Data Dataset job returned by every <code>.trigger</code>
call.

**@example Wait for results**
```ruby
snapshot = client.linkedin.profiles.trigger(urls: ["https://www.linkedin.com/in/example/"])
result = snapshot.wait
result.success? # => true
```

## Constants
### `DEFAULT_POLL_INTERVAL` <a id="constant-DEFAULT_POLL_INTERVAL"></a> <a id="DEFAULT_POLL_INTERVAL-constant"></a>
- **@return** [Integer] default poll interval in seconds

### `DEFAULT_TIMEOUT` <a id="constant-DEFAULT_TIMEOUT"></a> <a id="DEFAULT_TIMEOUT-constant"></a>
- **@return** [Integer] default wait timeout in seconds

### `PROGRESS_PATH_TEMPLATE` <a id="constant-PROGRESS_PATH_TEMPLATE"></a> <a id="PROGRESS_PATH_TEMPLATE-constant"></a>
- **@return** [String] progress endpoint template

### `RESULTS_PATH_TEMPLATE` <a id="constant-RESULTS_PATH_TEMPLATE"></a> <a id="RESULTS_PATH_TEMPLATE-constant"></a>
- **@return** [String] results endpoint template

### `STATUSES` <a id="constant-STATUSES"></a> <a id="STATUSES-constant"></a>
- **@return** [Array<Symbol>] statuses recognized by Bright Data snapshot progress

### `TRIGGER_RESPONSE_KEY` <a id="constant-TRIGGER_RESPONSE_KEY"></a> <a id="TRIGGER_RESPONSE_KEY-constant"></a>
- **@return** [Symbol] trigger response key containing the snapshot ID

## Attributes
### `id` [R] <a id="attribute-i-id"></a> <a id="id-instance_method"></a>
- **@return** [String] snapshot ID

### `status` [R] <a id="attribute-i-status"></a> <a id="status-instance_method"></a>
- **@return** [Symbol] latest known status

## Public Instance Methods
### `failed?()` <a id="method-i-failed-3F"></a> <a id="failed?-instance_method"></a>
- **@return** [Boolean] true when the latest status is failed

### `initialize(id:, http:, result_parser: = ->(raw) { raw })` <a id="method-i-initialize"></a> <a id="initialize-instance_method"></a>
- **@param** `id` [String] snapshot ID from `/datasets/v3/trigger`
- **@param** `http` [BrightData::HTTP] HTTP wrapper
- **@param** `result_parser` [#call] callable mapping raw result arrays to typed results
- **@return** [Snapshot] a new instance of Snapshot

### `progress()` <a id="method-i-progress"></a> <a id="progress-instance_method"></a>
Poll progress once.
- **@raise** [BrightData::Error] if Bright Data returns an unknown status
- **@return** [Symbol] current snapshot status

### `ready?()` <a id="method-i-ready-3F"></a> <a id="ready?-instance_method"></a>
- **@return** [Boolean] true when the latest status is ready

### `results()` <a id="method-i-results"></a> <a id="results-instance_method"></a>
Fetch raw snapshot results.
- **@return** [Array] raw JSON result array

### `wait(timeout: = DEFAULT_TIMEOUT, poll_interval: = DEFAULT_POLL_INTERVAL)` <a id="method-i-wait"></a> <a id="wait-instance_method"></a>
Block until the snapshot reaches a terminal status or timeout elapses.
- **@param** `timeout` [Numeric] seconds to wait before raising
- **@param** `poll_interval` [Numeric] seconds between progress polls
- **@raise** [BrightData::ScrapeTimeoutError] if timeout elapses before a terminal status
- **@return** [SimpleResult::Success] success result containing parsed results
- **@return** [SimpleResult::Failure] failure result containing the progress payload
