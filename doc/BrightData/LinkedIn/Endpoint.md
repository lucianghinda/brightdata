# Module BrightData::LinkedIn::Endpoint <a id="module-BrightData-LinkedIn-Endpoint"></a>

Shared trigger/scrape helpers for LinkedIn endpoint classes.

Including this module gives a class the {ClassMethods#endpoint} macro, which
declares a whole endpoint mode (its <code>#initialize</code>,
<code>#trigger</code>, <code>#scrape</code>, input validation, and result
parsing) from a few keywords.

- **@api** private

## Constants
### `SCRAPE_PATH` <a id="constant-SCRAPE_PATH"></a> <a id="SCRAPE_PATH-constant"></a>
- **@api** private
- **@return** [String] Bright Data synchronous scrape path

### `TRIGGER_PATH` <a id="constant-TRIGGER_PATH"></a> <a id="TRIGGER_PATH-constant"></a>
- **@api** private
- **@return** [String] Bright Data trigger path

## Public Class Methods
### `included(base)` <a id="method-c-included"></a> <a id="included-class_method"></a>
- **@api** private
- **@param** `base` [Class] including class
