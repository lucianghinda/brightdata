# Class BrightData::LinkedIn::Types::Post <a id="class-BrightData-LinkedIn-Types-Post"></a>

**Inherits:** `Data`

Typed representation of a LinkedIn post response.

- **@note** Use #raw to access fields not yet typed by this gem.

## Attributes
### `comments_count` [R] <a id="attribute-i-comments_count"></a> <a id="comments_count-instance_method"></a>
- **@return** [Integer, String, nil] comment count

### `date_posted` [R] <a id="attribute-i-date_posted"></a> <a id="date_posted-instance_method"></a>
- **@return** [String, nil] date posted

### `embedded_links` [R] <a id="attribute-i-embedded_links"></a> <a id="embedded_links-instance_method"></a>
- **@return** [Array<String>, nil] embedded links

### `hashtags` [R] <a id="attribute-i-hashtags"></a> <a id="hashtags-instance_method"></a>
- **@return** [Array<String>, nil] hashtags

### `headline` [R] <a id="attribute-i-headline"></a> <a id="headline-instance_method"></a>
- **@return** [String, nil] author headline

### `id` [R] <a id="attribute-i-id"></a> <a id="id-instance_method"></a>
- **@return** [String, nil] post ID

### `images` [R] <a id="attribute-i-images"></a> <a id="images-instance_method"></a>
- **@return** [Array<String>, nil] image URLs

### `likes` [R] <a id="attribute-i-likes"></a> <a id="likes-instance_method"></a>
- **@return** [Integer, String, nil] like count

### `original_post` [R] <a id="attribute-i-original_post"></a> <a id="original_post-instance_method"></a>
- **@return** [Hash, nil] original post details

### `post_text` [R] <a id="attribute-i-post_text"></a> <a id="post_text-instance_method"></a>
- **@return** [String, nil] post text

### `raw` [R] <a id="attribute-i-raw"></a> <a id="raw-instance_method"></a>
- **@return** [Hash] full parsed API response

### `repost` [R] <a id="attribute-i-repost"></a> <a id="repost-instance_method"></a>
- **@return** [Hash, nil] repost details

### `user_id` [R] <a id="attribute-i-user_id"></a> <a id="user_id-instance_method"></a>
- **@return** [String, nil] author user ID

### `videos` [R] <a id="attribute-i-videos"></a> <a id="videos-instance_method"></a>
- **@return** [Array<String>, nil] video URLs

## Public Class Methods
### `from_api(hash)` <a id="method-c-from_api"></a> <a id="from_api-class_method"></a>
Build a post from a symbol-keyed API response.
- **@param** `hash` [Hash] symbolized-key API response object
- **@return** [BrightData::LinkedIn::Types::Post]
