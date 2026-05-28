# Class BrightData::LinkedIn::Types::Job <a id="class-BrightData-LinkedIn-Types-Job"></a>

**Inherits:** `Data`

Typed representation of a LinkedIn job response.

- **@note** Use #raw to access fields not yet typed by this gem.

## Attributes
### `company_logo` [R] <a id="attribute-i-company_logo"></a> <a id="company_logo-instance_method"></a>
- **@return** [String, nil] company logo URL

### `company_name` [R] <a id="attribute-i-company_name"></a> <a id="company_name-instance_method"></a>
- **@return** [String, nil] company name

### `job_base_pay_range` [R] <a id="attribute-i-job_base_pay_range"></a> <a id="job_base_pay_range-instance_method"></a>
- **@return** [String, nil] base pay range

### `job_location` [R] <a id="attribute-i-job_location"></a> <a id="job_location-instance_method"></a>
- **@return** [String, nil] job location

### `job_posted_time` [R] <a id="attribute-i-job_posted_time"></a> <a id="job_posted_time-instance_method"></a>
- **@return** [String, nil] posted time

### `job_posting_id` [R] <a id="attribute-i-job_posting_id"></a> <a id="job_posting_id-instance_method"></a>
- **@return** [String, nil] job posting ID

### `job_summary` [R] <a id="attribute-i-job_summary"></a> <a id="job_summary-instance_method"></a>
- **@return** [String, nil] job summary

### `job_title` [R] <a id="attribute-i-job_title"></a> <a id="job_title-instance_method"></a>
- **@return** [String, nil] job title

### `raw` [R] <a id="attribute-i-raw"></a> <a id="raw-instance_method"></a>
- **@return** [Hash] full parsed API response

### `url` [R] <a id="attribute-i-url"></a> <a id="url-instance_method"></a>
- **@return** [String, nil] job URL

## Public Class Methods
### `from_api(hash)` <a id="method-c-from_api"></a> <a id="from_api-class_method"></a>
Build a job from a symbol-keyed API response.
- **@param** `hash` [Hash] symbolized-key API response object
- **@return** [BrightData::LinkedIn::Types::Job]
