# Class BrightData::LinkedIn::Types::JobKeywordInput <a id="class-BrightData-LinkedIn-Types-JobKeywordInput"></a>

**Inherits:** `Data`

Input shape for <code>linkedin.jobs.discover_by_keyword</code>.

## Attributes
### `company` [R] <a id="attribute-i-company"></a> <a id="company-instance_method"></a>
- **@return** [String, nil] company filter

### `country` [R] <a id="attribute-i-country"></a> <a id="country-instance_method"></a>
- **@return** [String, nil] country code

### `experience_level` [R] <a id="attribute-i-experience_level"></a> <a id="experience_level-instance_method"></a>
- **@return** [String, nil] experience level

### `job_type` [R] <a id="attribute-i-job_type"></a> <a id="job_type-instance_method"></a>
- **@return** [String, nil] job type

### `jobs_to_not_include` [R] <a id="attribute-i-jobs_to_not_include"></a> <a id="jobs_to_not_include-instance_method"></a>
- **@return** [String, Array<String>, nil] excluded jobs

### `keyword` [R] <a id="attribute-i-keyword"></a> <a id="keyword-instance_method"></a>
- **@return** [String, nil] job keyword

### `location` [R] <a id="attribute-i-location"></a> <a id="location-instance_method"></a>
- **@return** [String] target location

### `location_radius` [R] <a id="attribute-i-location_radius"></a> <a id="location_radius-instance_method"></a>
- **@return** [Integer, String, nil] location radius

### `remote` [R] <a id="attribute-i-remote"></a> <a id="remote-instance_method"></a>
- **@return** [String, Boolean, nil] remote filter

### `selective_search` [R] <a id="attribute-i-selective_search"></a> <a id="selective_search-instance_method"></a>
- **@return** [String, Boolean, nil] selective search flag

### `time_range` [R] <a id="attribute-i-time_range"></a> <a id="time_range-instance_method"></a>
- **@return** [String, nil] posting time range

## Public Instance Methods
### `to_api_hash()` <a id="method-i-to_api_hash"></a> <a id="to_api_hash-instance_method"></a>
Serialize for Bright Data, omitting nil values.
- **@return** [Hash] API input payload
