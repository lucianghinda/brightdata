# Tech Stack

## Decision Principles
1. **Zero non-stdlib runtime deps where feasible** — every dependency a gem adds is a dependency every consumer inherits. Default to stdlib (`Net::HTTP`, `json`); add only when stdlib genuinely costs the user.
2. **Modern Ruby only** — target Ruby 4.0+ so `Data.define`, pattern matching, and the `simple-result` dependency are available without polyfills.
3. **Keyword arguments everywhere** in public API — no positional args on any public method, ever. Internal helpers may use positional where natural.
4. **Test the wire, not the wrapper** — WebMock fixtures capture real Bright Data response shapes; tests fail loudly if the shape drifts.
5. **YARD documentation is non-optional** — every public class, method, parameter, and return type has a YARD tag block. CI fails on undocumented public API via `yard --fail-on-warning`.

## Stack

| Layer | Choice | Rationale |
|-------|--------|-----------|
| Language | Ruby ≥ 4.0 | `simple-result` 0.3.1 requires modern Ruby; `Data.define` and pattern matching stay available; no polyfill burden |
| HTTP client | `Net::HTTP` (stdlib) | Zero runtime deps. Bright Data's API is JSON-over-HTTPS — Faraday's extensibility buys us nothing for v0.1. Encapsulated behind `BrightData::HTTP` so swapping to Faraday later is a one-file change |
| JSON | `json` (stdlib) | Self-evident |
| Result types | `simple-result` (~> 0.3.1) | User-specified; lightweight, no monad-language baggage |
| Value objects | `Data.define` (stdlib, Ruby 4.0+) | User-specified; immutable, `==`, `to_h`, pattern-matchable; zero deps |
| Test framework | `minitest` | Stdlib, fast, no DSL ceremony |
| HTTP test stubs | `webmock` (~> 3.0) | User-specified |
| Test data | Hand-curated JSON fixtures in `test/fixtures/` keyed by endpoint | Real captured responses; rotated manually when API shapes drift |
| Doc generator | `yard` | User-specified; gem-standard; integrates with RubyDoc.info |
| Linter | `standard` | Zero-config Ruby style; community default for new gems; runs in CI |
| CI | GitHub Actions matrix: Ruby 4.0 on ubuntu-latest | Matches the gem's runtime dependency floor |
| Release | `bundle gem` scaffold + `rake release` | Standard Bundler workflow |
| Versioning | SemVer; pre-1.0 minor bumps may break, documented in CHANGELOG | Standard pre-1.0 contract |

## Gem Dependencies (final list for `brightdata.gemspec`)

**Runtime:**
- `simple-result ~> 0.3.1`

**Development:**
- `minitest ~> 5.0`
- `webmock ~> 3.0`
- `yard ~> 0.9`
- `standard ~> 1.0`
- `rake ~> 13.0`

## Project Layout

```
brightdata/
├── lib/
│   ├── brightdata.rb                 # autoloads everything, BrightData::VERSION
│   └── brightdata/
│       ├── client.rb                 # BrightData::Client (entry point)
│       ├── http.rb                   # Net::HTTP wrapper
│       ├── snapshot.rb               # BrightData::Snapshot (poll/wait/results)
│       ├── errors.rb                 # error hierarchy
│       ├── version.rb
│       └── linkedin/
│           ├── namespace.rb          # BrightData::LinkedIn entry (client.linkedin)
│           ├── profiles.rb
│           ├── companies.rb
│           ├── jobs.rb
│           ├── posts.rb
│           ├── people.rb
│           └── types/                # Data.define classes (one file per endpoint)
│               ├── profile.rb
│               ├── company.rb
│               └── ...
├── test/
│   ├── test_helper.rb
│   ├── fixtures/
│   │   └── linkedin/
│   │       ├── profiles_collect_by_url.json
│   │       └── ...
│   ├── brightdata/
│   │   ├── client_test.rb
│   │   ├── snapshot_test.rb
│   │   └── linkedin/
│   │       ├── profiles_test.rb
│   │       └── ...
├── docs/                             # planning artifacts (this directory)
├── .github/workflows/ci.yml
├── .yardopts
├── .standard.yml
├── CHANGELOG.md
├── README.md
├── LICENSE.txt
├── brightdata.gemspec
├── Gemfile
└── Rakefile
```

## Alternatives Rejected

| Alternative | Why Rejected |
|-------------|-------------|
| Faraday + faraday-retry | Adds runtime dep for value the v0.1 gem doesn't need. Encapsulated `BrightData::HTTP` means we can switch in v0.2+ if `notify` webhooks or retry middlewares justify it |
| `dry-struct` / `dry-types` | `Data.define` covers value-object needs in <0 deps; dry-rb adds large transitive deps for a small API surface |
| RSpec | Minitest matches the "stdlib-first" stance and reads cleaner for a small library. Not a strong preference; flag for revision if you want RSpec |
| Sorbet / RBS at v0.1 | YARD covers documentation contract; types follow in v0.9 once the API has settled across multiple namespaces |
| `httparty` | Smaller than Faraday but still a runtime dep with its own opinions; `Net::HTTP` is sufficient |
| `Struct.new` for response types | No immutability, no pattern-match friendly equality, mutable attrs leak through; `Data.define` is strictly better here |
| OpenStruct / Hashie | Untyped, slow, opaque; defeats the typed-output goal |
| Hand-written CHANGELOG.md skipping Keep-a-Changelog format | Pre-1.0 churn benefits from the discipline; adopt Keep-a-Changelog from v0.1.0 |
