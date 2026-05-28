# Class BrightData::LinkedIn::Types::PeopleDiscoverInput <a id="class-BrightData-LinkedIn-Types-PeopleDiscoverInput"></a>

**Inherits:** `Data`

Input shape for <code>linkedin.people.discover_new_profiles</code>.

## Attributes
### `first_name` [R] <a id="attribute-i-first_name"></a> <a id="first_name-instance_method"></a>
- **@return** [String, nil] first name to search by

### `last_name` [R] <a id="attribute-i-last_name"></a> <a id="last_name-instance_method"></a>
- **@return** [String, nil] last name to search by

### `url` [R] <a id="attribute-i-url"></a> <a id="url-instance_method"></a>
- **@return** [String] must be `https://www.linkedin.com`

## Public Instance Methods
### `to_api_hash()` <a id="method-i-to_api_hash"></a> <a id="to_api_hash-instance_method"></a>
Serialize for Bright Data, omitting nil values.
- **@return** [Hash] API input payload
