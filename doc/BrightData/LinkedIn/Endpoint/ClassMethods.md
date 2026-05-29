# Module BrightData::LinkedIn::Endpoint::ClassMethods <a id="module-BrightData-LinkedIn-Endpoint-ClassMethods"></a>

Declarative endpoint builder mixed into classes that include {Endpoint}.

- **@api** private

## Public Instance Methods
### `endpoint(dataset_key:, result:, param:, input: = nil, input_type: = nil, extra_query: = {})` <a id="method-i-endpoint"></a> <a id="endpoint-instance_method"></a>
Declare an endpoint mode.

Generates `#initialize(http:)`, <code>#trigger</code>/<code>#scrape</code>
(with a real keyword argument named after `param`), input validation, and
result parsing. Pass either `input` (each value is a URL string wrapped in
that input class) or `input_type` (each value must already be an instance of
that type).
- **@api** private
- **@param** `dataset_key` [Symbol] key in {BrightData::Datasets::LINKEDIN}
- **@param** `result` [#from_api] result class for parsing responses
- **@param** `param` [Symbol] public keyword argument name, e.g. `:urls`
- **@param** `input` [Class, nil] URL-input class wrapping each string value
- **@param** `input_type` [Class, nil] required type for each pre-built value
- **@param** `extra_query` [Hash] extra Bright Data query params
- **@return** [void]
