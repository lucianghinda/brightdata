# Class BrightData::LinkedIn::Types::Company <a id="class-BrightData-LinkedIn-Types-Company"></a>

**Inherits:** `Data`

Immutable value object representing a LinkedIn company response.

- **@note** Use #raw to access fields the gem does not yet model.

## Attributes
### `affiliated` [R] <a id="attribute-i-affiliated"></a> <a id="affiliated-instance_method"></a>
- **@return** [Array<Hash>, nil] affiliated companies

### `company_id` [R] <a id="attribute-i-company_id"></a> <a id="company_id-instance_method"></a>
- **@return** [String, nil] LinkedIn company ID

### `company_size` [R] <a id="attribute-i-company_size"></a> <a id="company_size-instance_method"></a>
- **@return** [String, nil] company size

### `country_code` [R] <a id="attribute-i-country_code"></a> <a id="country_code-instance_method"></a>
- **@return** [String, nil] country code

### `employees` [R] <a id="attribute-i-employees"></a> <a id="employees-instance_method"></a>
- **@return** [Array<Hash>, nil] employees

### `employees_in_linkedin` [R] <a id="attribute-i-employees_in_linkedin"></a> <a id="employees_in_linkedin-instance_method"></a>
- **@return** [Integer, String, nil] LinkedIn employee count

### `followers` [R] <a id="attribute-i-followers"></a> <a id="followers-instance_method"></a>
- **@return** [Integer, String, nil] follower count

### `founded` [R] <a id="attribute-i-founded"></a> <a id="founded-instance_method"></a>
- **@return** [String, Integer, nil] founded year

### `funding` [R] <a id="attribute-i-funding"></a> <a id="funding-instance_method"></a>
- **@return** [Hash, nil] funding details

### `headquarters` [R] <a id="attribute-i-headquarters"></a> <a id="headquarters-instance_method"></a>
- **@return** [Hash, nil] headquarters

### `id` [R] <a id="attribute-i-id"></a> <a id="id-instance_method"></a>
- **@return** [String, nil] company ID

### `image` [R] <a id="attribute-i-image"></a> <a id="image-instance_method"></a>
- **@return** [String, nil] image URL

### `industries` [R] <a id="attribute-i-industries"></a> <a id="industries-instance_method"></a>
- **@return** [Array<String>, nil] industries

### `investors` [R] <a id="attribute-i-investors"></a> <a id="investors-instance_method"></a>
- **@return** [Array<Hash>, nil] investors

### `locations` [R] <a id="attribute-i-locations"></a> <a id="locations-instance_method"></a>
- **@return** [Array<Hash>, nil] company locations

### `logo` [R] <a id="attribute-i-logo"></a> <a id="logo-instance_method"></a>
- **@return** [String, nil] logo URL

### `name` [R] <a id="attribute-i-name"></a> <a id="name-instance_method"></a>
- **@return** [String, nil] company name

### `raw` [R] <a id="attribute-i-raw"></a> <a id="raw-instance_method"></a>
- **@return** [Hash] full parsed API response

### `similar` [R] <a id="attribute-i-similar"></a> <a id="similar-instance_method"></a>
- **@return** [Array<Hash>, nil] similar companies

### `specialties` [R] <a id="attribute-i-specialties"></a> <a id="specialties-instance_method"></a>
- **@return** [Array<String>, nil] specialties

### `updates` [R] <a id="attribute-i-updates"></a> <a id="updates-instance_method"></a>
- **@return** [Array<Hash>, nil] updates

### `website` [R] <a id="attribute-i-website"></a> <a id="website-instance_method"></a>
- **@return** [String, nil] company website

## Public Class Methods
### `from_api(hash)` <a id="method-c-from_api"></a> <a id="from_api-class_method"></a>
Build a company from a symbol-keyed API response.
- **@param** `hash` [Hash] symbolized-key API response object
- **@return** [BrightData::LinkedIn::Types::Company]
