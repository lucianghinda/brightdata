# Module SimpleResult <a id="module-SimpleResult"></a>

Compatibility constructors for the re-exported <code>simple-result</code>
module.

## Public Class Methods
### `failure(error = nil)` <a id="method-c-failure"></a> <a id="failure-class_method"></a>
Build a failed result.
- **@param** `error` [Object, nil] failure error
- **@return** [SimpleResult::Failure]

### `success(payload = nil)` <a id="method-c-success"></a> <a id="success-class_method"></a>
Build a successful result.
- **@param** `payload` [Object, nil] success payload
- **@return** [SimpleResult::Success]
