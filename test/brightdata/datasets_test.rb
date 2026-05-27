# frozen_string_literal: true

require "test_helper"

module BrightData
  class DatasetsTest < Minitest::Test
    EXPECTED_LINKEDIN_KEYS = %i[
      profiles_collect_by_url
      companies_collect_by_url
      jobs_collect_by_url
      jobs_discover_by_url
      jobs_discover_by_keyword
      posts_collect_by_url
      posts_discover_by_profile_url
      posts_discover_by_url
      posts_discover_by_company_url
      people_discover_new_profiles
    ].freeze

    def test_linkedin_registry_contains_all_dataset_keys
      assert_equal EXPECTED_LINKEDIN_KEYS.sort, Datasets::LINKEDIN.keys.sort
    end

    def test_id_for_returns_dataset_id
      assert_equal "gd_l1viktl72bvl7bjuj0", Datasets.id_for(:profiles_collect_by_url)
    end

    def test_id_for_unknown_key_raises_bright_data_argument_error
      error = assert_raises(BrightData::ArgumentError) do
        Datasets.id_for(:unknown)
      end

      assert_match "Unknown LinkedIn dataset key: :unknown", error.message
    end

    def test_linkedin_registry_remains_mutable_for_overrides
      refute Datasets::LINKEDIN.frozen?
    end
  end
end
