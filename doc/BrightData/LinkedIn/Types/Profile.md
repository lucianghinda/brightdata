# Class BrightData::LinkedIn::Types::Profile <a id="class-BrightData-LinkedIn-Types-Profile"></a>

**Inherits:** `Data`

Immutable value object representing a LinkedIn profile response.

- **@note** Use #raw to access fields the gem does not yet model.

## Attributes
### `about` [R] <a id="attribute-i-about"></a> <a id="about-instance_method"></a>
- **@return** [String, nil] about text

### `avatar` [R] <a id="attribute-i-avatar"></a> <a id="avatar-instance_method"></a>
- **@return** [String, nil] avatar URL

### `banner_image` [R] <a id="attribute-i-banner_image"></a> <a id="banner_image-instance_method"></a>
- **@return** [String, nil] banner image URL

### `city` [R] <a id="attribute-i-city"></a> <a id="city-instance_method"></a>
- **@return** [String, nil] profile city

### `connections` [R] <a id="attribute-i-connections"></a> <a id="connections-instance_method"></a>
- **@return** [Integer, String, nil] connection count

### `country_code` [R] <a id="attribute-i-country_code"></a> <a id="country_code-instance_method"></a>
- **@return** [String, nil] profile country code

### `current_company` [R] <a id="attribute-i-current_company"></a> <a id="current_company-instance_method"></a>
- **@return** [Hash, nil] current company details

### `education` [R] <a id="attribute-i-education"></a> <a id="education-instance_method"></a>
- **@return** [Array<Hash>, nil] education entries

### `experience` [R] <a id="attribute-i-experience"></a> <a id="experience-instance_method"></a>
- **@return** [Array<Hash>, nil] experience entries

### `followers` [R] <a id="attribute-i-followers"></a> <a id="followers-instance_method"></a>
- **@return** [Integer, String, nil] follower count

### `id` [R] <a id="attribute-i-id"></a> <a id="id-instance_method"></a>
- **@return** [String, nil] profile ID

### `input_url` [R] <a id="attribute-i-input_url"></a> <a id="input_url-instance_method"></a>
- **@return** [String, nil] requested input URL

### `linkedin_id` [R] <a id="attribute-i-linkedin_id"></a> <a id="linkedin_id-instance_method"></a>
- **@return** [String, nil] LinkedIn vanity ID

### `linkedin_num_id` [R] <a id="attribute-i-linkedin_num_id"></a> <a id="linkedin_num_id-instance_method"></a>
- **@return** [String, Integer, nil] LinkedIn numeric ID

### `name` [R] <a id="attribute-i-name"></a> <a id="name-instance_method"></a>
- **@return** [String, nil] profile name

### `people_also_viewed` [R] <a id="attribute-i-people_also_viewed"></a> <a id="people_also_viewed-instance_method"></a>
- **@return** [Array<Hash>, nil] related profiles

### `position` [R] <a id="attribute-i-position"></a> <a id="position-instance_method"></a>
- **@return** [String, nil] current position

### `raw` [R] <a id="attribute-i-raw"></a> <a id="raw-instance_method"></a>
- **@return** [Hash] full parsed API response

## Public Class Methods
### `from_api(hash)` <a id="method-c-from_api"></a> <a id="from_api-class_method"></a>
Build a profile from a symbol-keyed API response.
- **@param** `hash` [Hash] symbolized-key API response object
- **@return** [BrightData::LinkedIn::Types::Profile]
