# Mission

## One-Sentence Mission
The `brightdata` gem exists to give Ruby developers a typed, ergonomic, well-documented client for Bright Data's scraper APIs so they can integrate web data into their applications in two lines instead of fifty.

## Job Story
When I'm building a Ruby application that needs LinkedIn data via Bright Data, I struggle with the boilerplate of constructing trigger requests, polling snapshots, parsing untyped responses, and handling errors consistently, so I currently write ad-hoc HTTP code that doesn't generalize across endpoints.
I'd hire a Ruby gem that gives me typed inputs, typed outputs, explicit `trigger`/`scrape` verbs, and Result-based error handling so I can call any LinkedIn endpoint in two lines.

## Why We're Right to Build This
- **Operational experience:** the author has shipped multiple production Ruby gems and integrations against third-party APIs with snapshot/polling semantics.
- **Domain context:** Bright Data publishes 100+ scraper endpoints over a consistent Datasets v3 surface, but no idiomatic Ruby SDK exists today — every Ruby user is reinventing trigger/poll/parse code.
- **Taste fit:** the gem leans on Ruby 4.0+ language features (`Data.define`, keyword-only arguments, pattern matching) that suit a typed-but-thin client without dragging in ActiveSupport or other heavyweight deps.

## Who We Serve
Mid-to-senior Ruby developers integrating Bright Data into Rails apps, data pipelines, or back-office tooling. They know HTTP, they know what `Net::HTTP` costs them in boilerplate, and they want a gem that disappears into their app — not a framework.

## The Problem We Solve
Today these developers write ~50–100 lines of `Net::HTTP` / Faraday glue per endpoint: URL construction, header setup, JSON encoding, snapshot polling, status mapping, response parsing. The code doesn't generalize across the 10+ LinkedIn endpoints they need, and every error path is hand-rolled. Result: brittle integrations, copy-paste drift between endpoints, no shared error vocabulary.

## Why Now
- Ruby 4.0+ includes `Data.define`, making typed value objects ergonomic without `dry-struct` or `Struct.new`.
- Bright Data's Datasets v3 API has stabilized around `/trigger`, `/scrape`, `/progress`, `/snapshot` — a coherent surface worth wrapping.
- Bright Data has not shipped an official Ruby SDK; the window to become the de facto one is open.

## What Success Looks Like (Year 1)
- v1.0 published to RubyGems with all 10 LinkedIn endpoints stable
- ≥50 GitHub stars, ≥5 production users (self-reported via issues/discussions)
- 100% YARD coverage on public API; full RBS or Sorbet-compatible signatures for input/output `Data` classes
- ≥1 second Bright Data namespace shipped (e.g., `BrightData::Twitter` or `BrightData::Amazon`) proving the architecture generalizes
