# Changelog

All notable changes to this project will be documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2026-05-28

Initial public release.

### Added
- `BrightData::Client` with configurable `api_token`, `base_url`, and `logger`.
- LinkedIn endpoints under `client.linkedin`:
  - `profiles` and `companies` (collect by URL)
  - `jobs.collect_by_url`, `jobs.discover_by_url`, `jobs.discover_by_keyword`
  - `posts.collect_by_url`, `posts.discover_by_url`,
    `posts.discover_by_profile_url`, `posts.discover_by_company_url`
  - `people.discover_new_profiles`
- Every endpoint exposes both `#scrape` (synchronous, parsed results) and
  `#trigger` (asynchronous, returns a `Snapshot`).
- `BrightData::Snapshot#wait` polling with configurable `timeout` and
  `poll_interval`, returning a `BrightData::Result` (`SimpleResult::Success` or
  `Failure`).
- Immutable `Data`-backed result objects (`Profile`, `Company`, `Job`, `Post`,
  `DiscoveredProfile`) and input objects (`JobKeywordInput`,
  `PeopleDiscoverInput`, and `*UrlInput` variants), each exposing named readers
  plus `#raw`.
- Error hierarchy rooted at `BrightData::Error`: `ConfigurationError`,
  `ArgumentError`, `AuthError`, `HTTPError`, `RateLimitError` (`#retry_after`),
  `ServerError`, `ScrapeTimeoutError` (`#snapshot`).
- Mutable `BrightData::Datasets::LINKEDIN` registry for overriding or adding
  dataset IDs at runtime.
- Optional request/response tracing via `BRIGHTDATA_LIVE`, recorded under
  `tmp/live/`.
- `llm.md` — single-file, LLM-friendly reference generated from YARD docs via
  `bin/generate_llm.rb` and `bin/prepare_release`.
