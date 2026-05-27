# Session Q&A Log: BrightData Ruby Gem (v0.1.0 LinkedIn)

**Date:** 2026-05-24
**Mode:** New Product
**Scope:** Standard
**Phases completed:** 0, 1, 2, 3, 4, 5, 7 (Phase 6 skipped — no confidence gaps after gauntlet)
**Outcome:** Full plan produced. 4 product documents (`mission.md`, `mvp-plan.md`, `roadmap.md`, `tech-stack.md`) + 1 implementation plan (`v0.1.0-linkedin-plan.md`) with 15 units, requirements trace, and Phase 5 gauntlet amendments. No implementation work performed; plan IS the output.

---

## Questions & Answers by Phase

### Phase 0: Intake & Route

No explicit user questions — mode and scope were inferred from the empty directory + the rich initial brief (Bright Data, LinkedIn, webmock, simple-result, Data, keyword args). Routed to **New Product / Standard scope** without asking.

---

### Phase 2: Challenge & Explore

**Q:** Async-first API design: should the default public API return a Snapshot you wait/poll, with a sync convenience method on top? (Options: Async-first / Sync-first with async escape / Two explicit verbs)
**User:** Two explicit verbs.
**AI position:** Recommended async-first (`.collect` returns Snapshot; `.collect_sync` convenience). Argued it matches Bright Data's real behavior and teaches the right mental model.
**Resolved:** User chose "two explicit verbs" (`.trigger` + `.scrape` per endpoint). AI accepted — cleanest, lowest-abstraction option, matches Bright Data's `/trigger` vs `/scrape` split exactly.

**Q:** Result handling: when does the gem raise vs return a SimpleResult? (Hybrid / Always return Result / Always raise)
**User:** Hybrid.
**AI position:** Recommended Hybrid (raise on programmer/auth errors; SimpleResult at network boundary for transient errors, snapshot failures).
**Resolved:** Agreed. Hybrid model locked in.

**Q:** MVP scope: which of the 10 LinkedIn endpoints ship in v0.1.0? (2 / 4 collect / all 10)
**User:** All 10 endpoints.
**AI position:** Recommended 2 endpoints (profiles + companies) as narrow wedge.
**Resolved (after one round of pushback):** User held the call on all 10.

**Q (pushback):** Concrete cost of all 10 in v0.1.0 — 6 discover endpoints have meaningfully different input shapes than 4 collect endpoints; v0.2 may need to rename input classes, requiring 1.0 bump. Alternative: ship all 10 structurally, mark 6 discover as `@api experimental` to reserve semver flexibility.
**User:** Hold — all 10 stable in v0.1.0.
**AI position:** Pushed once with concrete cost. Accepted on second hold per anti-sycophancy rules (one push, then accept).
**Resolved:** All 10 endpoints ship under semver in v0.1.0. Input class renames documented as the trigger for 1.0 in CHANGELOG.

---

### Phase 3: Define (Gate 2→3 transition)

**Q:** Ready to proceed to Phase 3 (Define)? Generate 4 product documents in sequence?
**User:** Proceed.
**AI position:** Offered Proceed, Compress (one combined doc), or Skip (straight to Phase 4). Took position that 4 separate docs is right for New Product mode and brief is detailed enough to populate them fully.
**Resolved:** Proceed with 4-doc sequence.

**Q:** Approve mission.md as drafted?
**User:** Approve and save.
**Resolved:** Saved to `docs/product/mission.md`, committed.

**Q:** Approve mvp-plan.md as drafted?
**User:** Approve and save.
**Resolved:** Saved to `docs/product/mvp-plan.md`, committed.

**Q:** Approve roadmap.md as drafted?
**User:** Approve and save.
**Resolved:** Saved to `docs/product/roadmap.md`, committed.

**Q:** Approve tech-stack.md as drafted?
**User:** Approve and save.
**AI position:** Offered an explicit "switch to RSpec" option since minitest was the more debatable choice in the doc. User chose minitest.
**Resolved:** Saved to `docs/product/tech-stack.md`, committed.

**Mid-phase user message:** "Use yard to document all endpoint implemented."
**AI position:** Treated as a tech-stack amendment. Baked YARD into tech-stack.md ("YARD documentation is non-optional" principle + CI step `yard --fail-on-warning`) and into requirements (R10) and Unit 14 in the implementation plan.

---

### Phase 4: Structure (Step 4.0 clarifications)

**Q:** How should the gem handle the `dataset_id` per endpoint? (Hardcoded constants / Centralized registry / Configurable at Client.new)
**User:** Centralized registry in config.
**AI position:** Recommended hardcoded per-endpoint constants (simpler, no extra module). User chose centralized.
**Resolved:** `BrightData::Datasets` module as single source of truth (Unit 4 in plan).

**Q:** Should `Snapshot#wait` have a default timeout, or require the caller to pass one? (Defaults 300s/5s / Required kwargs / Hybrid)
**User:** Default 5 minutes, default 5s poll interval.
**AI position:** Recommended same. Beginner-friendly; `Float::INFINITY` available for unbounded.
**Resolved:** `wait(timeout: 300, poll_interval: 5)`.

**Q:** What should happen on `Snapshot#wait` when status becomes `failed`? (SimpleResult::Failure / raise SnapshotFailedError / return Snapshot)
**User:** Return SimpleResult::Failure.
**AI position:** Recommended same — matches the hybrid error model. Caller pattern-matches on `success?`.
**Resolved:** `wait` returns `Result.success(parsed_results)` on ready, `Result.failure(details)` on failed, raises `ScrapeTimeoutError` on timeout.

**Q:** Live vs mocked tests — default test run behavior? (Mocked + :live opt-in / Mocked only / VCR cassettes)
**User:** WebMock-only by default; :live tag opt-in.
**AI position:** Recommended same. CI never runs live; contributors can opt in with `BRIGHTDATA_LIVE=1`.
**Resolved:** Two rake tasks: `rake test` (mocked) and `rake test:live` (gated on env var).

---

### Phase 5: Validate

**Q:** Phase 5 review scope mode — how should reviewers approach the plan? (HOLD SCOPE / SCOPE REDUCTION / Skip gauntlet / Engineering only)
**User:** HOLD SCOPE.
**AI position:** Recommended HOLD — plan was already well-scoped; gauntlet's job was to bulletproof.
**Resolved:** Ran CEO + DX (reframed from Design since no UI) + Engineering reviews sequentially. Surfaced 1 P0 + 8 P1 + 4 P2. All P0/P1 either resolved in-plan (E1 the timeout fix) or assigned to specific units for implementation-time application. Plan amended; commit `697b517`.

---

### Phase 7: Hand Off

**Q:** Next step?
**User:** Done — the plan IS the output.
**AI position:** Recommended "Begin implementation with Unit 1" (reversible, unblocks O1 fixture capture mid-flow).
**Resolved:** User ended session at plan. No implementation work performed. Session Q&A log saved (this file).

---

## Key Decisions

| Decision | Chosen | Phase | Rationale |
|----------|--------|-------|-----------|
| Public API verbs | Two explicit verbs: `.trigger` (Snapshot) + `.scrape` (results) per endpoint | 2 | Lowest abstraction; matches Bright Data's `/trigger` vs `/scrape` split exactly |
| Error handling | Hybrid — raise on programmer/auth; SimpleResult at network boundary | 2 | Idiomatic Ruby for unexpected; Result for expected failure-mode branching |
| MVP scope | All 10 LinkedIn endpoints in v0.1.0 under semver | 2 | User judgment; AI pushed back once on risk of needing 1.0 for input renames |
| Dataset ID storage | Centralized `BrightData::Datasets` registry module | 4 | Single source of truth; scales to v0.4+ namespaces |
| Snapshot#wait defaults | `timeout: 300, poll_interval: 5` | 4 | Beginner-friendly; `Float::INFINITY` opt-out for unbounded |
| Snapshot#wait return | `SimpleResult::Success/Failure` | 4 | Matches hybrid error model; caller pattern-matches on terminal state |
| Test mode | WebMock by default; `BRIGHTDATA_LIVE=1` opt-in | 4 | CI never hits real API; contributors can opt into live |
| HTTP read_timeout | 90s (> Bright Data /scrape 60s cap) | 5 (P0 finding E1) | Prevents TCP timeout from swallowing the `{snapshot_id}` fallback body |
| Memoization | Eager instantiation of namespaces at `Client#initialize` | 5 (P1 finding C1) | Thread-safe without Mutex; trivial cost (5 objects) |
| Logging | Opt-in `logger:` kwarg on `Client.new`; HTTP layer logs at :debug | 5 (P1 finding C2) | Production observability without forcing a logger choice |
| Rate limit | `RateLimitError#retry_after` parsed from `Retry-After` header | 5 (P1 finding C3) | Enables intelligent backoff in caller code |
| Discover endpoint kwargs | `profile_urls:` / `company_urls:` (semantic) instead of `urls:` | 5 (P1 finding D1) | Prevents bug where caller passes wrong URL type to wrong endpoint |
| YARD enforcement | `yard --fail-on-warning` blocks CI; 100% public API documentation | 3 + 4 | User mid-session request |
| HTTP client | `Net::HTTP` (stdlib), encapsulated behind `BrightData::HTTP` | 3 | Zero runtime deps; one-file swap path for v0.2+ Faraday if needed |
| Test framework | Minitest | 3 | Stdlib-first stance; less ceremony than RSpec |
| Linter | Standard | 3 | Zero-config; community default for new gems |

---

## Positions Where AI Pushed Back

| Topic | AI Position | User Response | Final Resolution |
|-------|------------|---------------|------------------|
| 10 endpoints in v0.1.0 vs narrow wedge | Pushed for either 2-endpoint MVP or "all 10 with discover marked `@api experimental`" to reserve semver flexibility | User held on all 10 stable | Accepted per anti-sycophancy rules (one push, then accept). Risk documented in CHANGELOG; input class rename = 1.0 trigger |
| Tech stack: minitest vs RSpec | Recommended minitest in draft but offered explicit "Switch to RSpec" option at approval time | User chose minitest (no rebuttal) | Minitest locked in |
| Default timeout for Snapshot#wait | Recommended having defaults (5min/5s) vs forcing explicit kwargs | User agreed | Defaults applied |
| HTTP read_timeout (Phase 5 P0) | Self-initiated finding: 60s == Bright Data's 60s cap = TCP timeout swallows snapshot_id | N/A (gauntlet finding, not user-facing) | Bumped to 90s in plan; gauntlet amendment committed |
| Lazy memoization on Client (Phase 5 P1) | Self-initiated finding: not thread-safe in Rails contexts | N/A | Switched to eager instantiation in U6 plan |
