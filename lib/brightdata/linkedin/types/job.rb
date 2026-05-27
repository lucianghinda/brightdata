# frozen_string_literal: true

module BrightData
  module LinkedIn
    module Types
      # Typed representation of a LinkedIn job response.
      #
      # @!attribute [r] url
      #   @return [String, nil] job URL
      # @!attribute [r] job_posting_id
      #   @return [String, nil] job posting ID
      # @!attribute [r] job_title
      #   @return [String, nil] job title
      # @!attribute [r] company_name
      #   @return [String, nil] company name
      # @!attribute [r] job_location
      #   @return [String, nil] job location
      # @!attribute [r] job_summary
      #   @return [String, nil] job summary
      # @!attribute [r] job_base_pay_range
      #   @return [String, nil] base pay range
      # @!attribute [r] job_posted_time
      #   @return [String, nil] posted time
      # @!attribute [r] company_logo
      #   @return [String, nil] company logo URL
      # @!attribute [r] raw
      #   @return [Hash] full parsed API response
      # @note Use #raw to access fields not yet typed by this gem.
      Job = Data.define(
        :url, :job_posting_id, :job_title, :company_name, :job_location,
        :job_summary, :job_base_pay_range, :job_posted_time, :company_logo, :raw
      ) do
        # Build a job from a symbol-keyed API response.
        #
        # @param hash [Hash] symbolized-key API response object
        # @return [BrightData::LinkedIn::Types::Job]
        def self.from_api(hash) # rubocop:disable Metrics/MethodLength -- flat field-by-field mapping from the API response
          new(
            url: hash[:url],
            job_posting_id: hash[:job_posting_id],
            job_title: hash[:job_title],
            company_name: hash[:company_name],
            job_location: hash[:job_location],
            job_summary: hash[:job_summary],
            job_base_pay_range: hash[:job_base_pay_range],
            job_posted_time: hash[:job_posted_time],
            company_logo: hash[:company_logo],
            raw: hash
          )
        end
      end
    end
  end
end
