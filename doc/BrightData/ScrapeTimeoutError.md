# Class BrightData::ScrapeTimeoutError <a id="class-BrightData-ScrapeTimeoutError"></a>

**Inherits:** `BrightData::Error`

Raised when <code>/scrape</code> exceeds Bright Data's 60-second synchronous
cap.

## Attributes
### `snapshot` [R] <a id="attribute-i-snapshot"></a> <a id="snapshot-instance_method"></a>
- **@return** [BrightData::Snapshot, nil] resumable snapshot returned by Bright Data

### `snapshot_id` [R] <a id="attribute-i-snapshot_id"></a> <a id="snapshot_id-instance_method"></a>
- **@return** [String] snapshot ID returned by Bright Data

## Public Instance Methods
### `initialize(message, snapshot_id:, snapshot: = nil)` <a id="method-i-initialize"></a> <a id="initialize-instance_method"></a>
- **@param** `message` [String] human-readable error message
- **@param** `snapshot_id` [String] snapshot ID returned by Bright Data
- **@param** `snapshot` [BrightData::Snapshot, nil] snapshot object that can be waited on
- **@return** [ScrapeTimeoutError] a new instance of ScrapeTimeoutError
