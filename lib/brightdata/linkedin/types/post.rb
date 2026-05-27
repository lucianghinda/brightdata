# frozen_string_literal: true

module BrightData
  module LinkedIn
    module Types
      # Typed representation of a LinkedIn post response.
      #
      # @!attribute [r] id
      #   @return [String, nil] post ID
      # @!attribute [r] user_id
      #   @return [String, nil] author user ID
      # @!attribute [r] headline
      #   @return [String, nil] author headline
      # @!attribute [r] post_text
      #   @return [String, nil] post text
      # @!attribute [r] date_posted
      #   @return [String, nil] date posted
      # @!attribute [r] hashtags
      #   @return [Array<String>, nil] hashtags
      # @!attribute [r] embedded_links
      #   @return [Array<String>, nil] embedded links
      # @!attribute [r] images
      #   @return [Array<String>, nil] image URLs
      # @!attribute [r] videos
      #   @return [Array<String>, nil] video URLs
      # @!attribute [r] likes
      #   @return [Integer, String, nil] like count
      # @!attribute [r] comments_count
      #   @return [Integer, String, nil] comment count
      # @!attribute [r] repost
      #   @return [Hash, nil] repost details
      # @!attribute [r] original_post
      #   @return [Hash, nil] original post details
      # @!attribute [r] raw
      #   @return [Hash] full parsed API response
      # @note Use #raw to access fields not yet typed by this gem.
      Post = Data.define(
        :id, :user_id, :headline, :post_text, :date_posted, :hashtags,
        :embedded_links, :images, :videos, :likes, :comments_count,
        :repost, :original_post, :raw
      ) do
        # Build a post from a symbol-keyed API response.
        #
        # @param hash [Hash] symbolized-key API response object
        # @return [BrightData::LinkedIn::Types::Post]
        def self.from_api(hash) # rubocop:disable Metrics/MethodLength -- flat field-by-field mapping from the API response
          new(
            id: hash[:id],
            user_id: hash[:user_id],
            headline: hash[:headline],
            post_text: hash[:post_text],
            date_posted: hash[:date_posted],
            hashtags: hash[:hashtags],
            embedded_links: hash[:embedded_links],
            images: hash[:images],
            videos: hash[:videos],
            likes: hash[:likes],
            comments_count: hash[:comments_count],
            repost: hash[:repost],
            original_post: hash[:original_post],
            raw: hash
          )
        end
      end
    end
  end
end
