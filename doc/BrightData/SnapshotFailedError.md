# Class BrightData::SnapshotFailedError <a id="class-BrightData-SnapshotFailedError"></a>

**Inherits:** `BrightData::Error`

Raised by explicit exception-based snapshot failure flows.

`Snapshot#wait` normally returns <code>SimpleResult::Failure</code> on failed
snapshots. This class is reserved for callers who opt into exception semantics
in future API versions.

## Attributes
### `details` [R] <a id="attribute-i-details"></a> <a id="details-instance_method"></a>
- **@return** [Hash, nil] failure details returned by Bright Data

### `snapshot_id` [R] <a id="attribute-i-snapshot_id"></a> <a id="snapshot_id-instance_method"></a>
- **@return** [String] snapshot ID

## Public Instance Methods
### `initialize(message, snapshot_id:, details: = nil)` <a id="method-i-initialize"></a> <a id="initialize-instance_method"></a>
- **@param** `message` [String] human-readable error message
- **@param** `snapshot_id` [String] snapshot ID
- **@param** `details` [Hash, nil] failure details returned by Bright Data
- **@return** [SnapshotFailedError] a new instance of SnapshotFailedError
