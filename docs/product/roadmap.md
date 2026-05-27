# Roadmap

## Phase 1: Prove It Works (v0.1.0 → v0.3.0)
**Hypothesis:** We believe Ruby developers will reach for a typed Bright Data SDK over hand-rolled `Net::HTTP` if the API surface is small and obvious. We'll know it's true when ≥3 non-author developers open issues describing real production use within 60 days of v0.1.0.

**Goal:** Ship all 10 LinkedIn endpoints with a polished, documented, tested public API; validate that the two-verb (`trigger`/`scrape`) + `Snapshot` model holds up in real use.

**Deliverables:**
- v0.1.0 — all 10 LinkedIn endpoints, Snapshot polling, hybrid errors, 100% YARD, WebMock test suite, README
- v0.2.0 — webhook delivery support (`notify` + caller-provided endpoint URL/secret); auto-retry adapter for transient 5xx (opt-in)
- v0.3.0 — Rails integration (ActiveJob adapter for snapshot polling) packaged as `brightdata-rails` complementary gem OR optional `require "brightdata/rails"`

**Exit criteria:** ≥3 non-author production users; <5 open bugs; one endpoint name refactor done OR explicitly declined.

## Phase 2: Make It Repeatable (v0.4.0 → v0.9.0)
**Hypothesis:** We believe the Datasets v3 abstraction (trigger/scrape/snapshot) generalizes cleanly across Bright Data's other social-media scrapers. We'll know it's true when adding a second namespace (e.g., `BrightData::Twitter`) takes <500 lines of net new code and zero changes to `BrightData::Client` or `BrightData::Snapshot`.

**Goal:** Prove the architecture by shipping a second namespace and capturing any abstractions that turned out to leak.

**Deliverables:**
- v0.4.0 — `BrightData::Twitter` namespace (3–4 endpoints)
- v0.5.0 — `BrightData::Instagram` namespace
- v0.6.0–0.8.0 — additional namespaces driven by user demand from GitHub issues
- v0.9.0 — RBS signatures shipped alongside the gem; type-checked CI

**Exit criteria:** ≥3 namespaces shipped; `Snapshot` and `Client` unchanged across them; RBS signatures published.

## Phase 3: Scale It (v1.0.0)
**Hypothesis:** We believe the gem is stable enough for semver guarantees. We'll know it's true when no breaking change has shipped in 90 days AND ≥10 production users have given feedback.

**Goal:** Stamp v1.0.0 with API stability commitment, ensure the gem is the canonical Ruby choice for Bright Data.

**Deliverables:**
- v1.0.0 — semver stability commitment; deprecation policy documented; CHANGELOG.md fully populated
- Bright Data partnership outreach (request listing in their official Ruby section if one exists)
- Conference talk submission (RubyConf, EuRuKo) about typed third-party API clients with `Data.define`

**Exit criteria:** v1.0.0 published; deprecation policy in place; ≥10 production users.

## Deferred (Backlog)
- **CLI binary** (`brightdata linkedin profiles scrape --url ...`) — fun but no clear demand signal; revisit if 3+ users ask
- **Native Access (proxy auth)** — needed only for users wanting raw proxy mode rather than scraper APIs; orthogonal architecture, large surface
- **Codegen from Bright Data's `llms.txt` or OpenAPI spec** — only justified if/when 5+ namespaces are shipped and maintenance burden bites
- **Streaming/cursor-based result retrieval** — Bright Data may add it; we don't preempt
- **Async/concurrent batch helpers** — wait for a real user request with a real shape; otherwise we'll over-design
