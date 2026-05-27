# MVP Plan

## Core Value Proposition
v0.1.0 must prove this single hypothesis: **a Ruby developer can collect LinkedIn data via Bright Data in two lines of code, with typed responses and no manual snapshot polling.**

```ruby
client = BrightData::Client.new(api_token: ENV["BRIGHTDATA_API_TOKEN"])
profiles = client.linkedin.profiles.scrape(urls: ["https://linkedin.com/in/elad-moshe-05a90413"])
# => Array of BrightData::LinkedIn::Profile (Data instances)
```

## MVP Scope

### Must Have (MVP gates on these)
- `BrightData::Client.new(api_token:)` — single entry point, keyword-only
- `BrightData::Client#linkedin` — namespace accessor
- Two verbs per endpoint: `.trigger(...)` returns `Snapshot`, `.scrape(...)` returns typed results
- `BrightData::Snapshot` with `#progress`, `#wait(timeout:, poll_interval:)`, `#results`, `#status`, `#failed?`, `#ready?`
- All 10 LinkedIn endpoints wired:
  - `linkedin.profiles.{trigger,scrape}` (collect_by_url)
  - `linkedin.companies.{trigger,scrape}` (collect_by_url)
  - `linkedin.jobs.{trigger,scrape}_by_url` (collect_by_url + discover_by_url)
  - `linkedin.jobs.discover_by_keyword.{trigger,scrape}`
  - `linkedin.posts.{trigger,scrape}_by_url` (collect_by_url)
  - `linkedin.posts.discover_by_profile_url.{trigger,scrape}`
  - `linkedin.posts.discover_by_url.{trigger,scrape}`
  - `linkedin.posts.discover_by_company_url.{trigger,scrape}`
  - `linkedin.people.discover_new_profiles.{trigger,scrape}`
- Input types as `Data.define` classes (per-endpoint, named after the endpoint)
- Response types as `Data.define` classes mirroring documented response shape
- Hybrid error model: `BrightData::AuthError`, `BrightData::ArgumentError` raised; `SimpleResult::Success/Failure` returned for network/snapshot outcomes
- 100% YARD documentation on public API surface (every endpoint, every input/output Data class)
- WebMock-driven test suite with recorded fixtures for each endpoint
- README with a 30-second quick start and an example per endpoint

### Explicitly Out of MVP
- Other Bright Data scrapers (Twitter, Instagram, Amazon, etc.) — deferred to v0.2+
- Webhook delivery / `notify` parameter integration — deferred
- Native Access (proxy username/password auth) — deferred; API key only
- Async/concurrent batch helpers (e.g., trigger N snapshots and wait for all) — deferred
- Rails integration (ActiveJob adapter for polling, ActiveRecord serializers) — deferred
- Auto-retry on transient 5xx — deferred (caller's responsibility in v0.1.0)
- CLI binary — deferred
- RBS / Sorbet signature files — deferred (YARD covers v0.1.0; types follow in v0.2)

## Go-to-Market Approach
1. Publish v0.1.0 to RubyGems under name `brightdata`
2. Post launch announcement: ShortRuby newsletter, r/ruby, Ruby Weekly submission, Bright Data community/forum
3. First-user channel: open a GitHub Discussion "Tell us how you're using it" and respond to every comment within 24h

## What We'll Do Manually (Pre-Scale)
- Response fixture capture: manually trigger each endpoint against a real Bright Data account once, save the JSON, hand-curate it into WebMock fixtures. Not automated.
- Issue triage and version bumps done by hand.
- Endpoint additions (v0.2+) added one at a time — no codegen, no auto-discovery of new Bright Data datasets. If/when the architecture proves stable across 3+ namespaces, revisit codegen.

## Success Metrics
| Metric | Target | Timeframe |
|--------|--------|-----------|
| RubyGems downloads | 500 | First 60 days |
| GitHub stars | 25 | First 90 days |
| Issues opened by non-author | 3+ | First 60 days (proves real use) |
| Endpoints with green CI | 10/10 | At v0.1.0 ship |
| YARD coverage on public API | 100% | At v0.1.0 ship |

## Biggest Risks
| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Bright Data ships official Ruby SDK during dev | L | H | Ship v0.1.0 quickly (target 2–3 weeks); design the API so wrapping an official client later is mechanical |
| Input field naming for `discover_*` endpoints turns out wrong → 1.0 needed early | M | M | Document this as known risk in CHANGELOG.md; treat input class renames as the trigger for 1.0 |
| Bright Data response shape drift breaks `Data.define` consumers | M | M | `Data.define` classes accept unknown keys via a single fallback `raw:` field; document this contract |
| WebMock fixtures rot vs real API | M | L | Tag a subset of specs as `:live` and skip by default; document the manual refresh workflow in CONTRIBUTING.md |
| 1-minute timeout on `/scrape` → users hit silent fallback behavior | M | M | `.scrape` documents the 60s cap explicitly; on timeout it raises `BrightData::ScrapeTimeoutError` with the `snapshot_id` so caller can switch to `.trigger`+`.wait` |
