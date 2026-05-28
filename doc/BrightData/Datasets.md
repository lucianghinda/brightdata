# Module BrightData::Datasets <a id="module-BrightData-Datasets"></a>

Registry of Bright Data dataset IDs keyed by symbolic endpoint name.

## Constants
### `LINKEDIN` <a id="constant-LINKEDIN"></a> <a id="LINKEDIN-constant"></a>
- **@return** [Hash{Symbol=>String}] LinkedIn dataset IDs

## Public Class Methods
### `id_for(key)` <a id="method-c-id_for"></a> <a id="id_for-class_method"></a>
Fetch a LinkedIn dataset ID.
- **@param** `key` [Symbol] symbolic endpoint name
- **@raise** [BrightData::ArgumentError] if key is unknown
- **@return** [String] dataset ID
