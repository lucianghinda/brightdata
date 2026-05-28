# Class BrightData::ArgumentError <a id="class-BrightData-ArgumentError"></a>

**Inherits:** `BrightData::Error`

Raised when a caller passes an invalid argument shape or value.

This class intentionally inherits from {BrightData::Error}, not from
<code>::ArgumentError</code>. Use `rescue BrightData::ArgumentError` or
`rescue BrightData::Error`.
