# Class BrightData::LinkedIn::Types::DiscoveredProfile <a id="class-BrightData-LinkedIn-Types-DiscoveredProfile"></a>

**Inherits:** `Data`

Immutable value object representing a discovered LinkedIn profile response.

- **@note** Use #raw to access fields the gem does not yet model.

## Attributes
### `avatar` [R] <a id="attribute-i-avatar"></a> <a id="avatar-instance_method"></a>
- **@return** [String, nil] avatar URL

### `education` [R] <a id="attribute-i-education"></a> <a id="education-instance_method"></a>
- **@return** [String, Hash, Array, nil] education summary

### `experience` [R] <a id="attribute-i-experience"></a> <a id="experience-instance_method"></a>
- **@return** [String, Hash, Array, nil] experience summary

### `location` [R] <a id="attribute-i-location"></a> <a id="location-instance_method"></a>
- **@return** [String, nil] profile location

### `name` [R] <a id="attribute-i-name"></a> <a id="name-instance_method"></a>
- **@return** [String, nil] profile name

### `raw` [R] <a id="attribute-i-raw"></a> <a id="raw-instance_method"></a>
- **@return** [Hash] full parsed API response

### `subtitle` [R] <a id="attribute-i-subtitle"></a> <a id="subtitle-instance_method"></a>
- **@return** [String, nil] profile subtitle

### `url` [R] <a id="attribute-i-url"></a> <a id="url-instance_method"></a>
- **@return** [String, nil] profile URL

## Public Class Methods
### `from_api(hash)` <a id="method-c-from_api"></a> <a id="from_api-class_method"></a>
Build a discovered profile from a symbol-keyed API response.
- **@param** `hash` [Hash] symbolized-key API response object
- **@return** [BrightData::LinkedIn::Types::DiscoveredProfile]
