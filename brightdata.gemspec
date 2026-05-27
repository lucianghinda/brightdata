# frozen_string_literal: true

require_relative "lib/brightdata/version"

Gem::Specification.new do |spec|
  spec.name = "brightdata"
  spec.version = BrightData::VERSION
  spec.authors = ["Lucian Ghinda"]
  spec.email = ["dev@ghinda.com"]
  spec.summary = "Ruby client for Bright Data scraper APIs"
  spec.description = "A typed, ergonomic Ruby client for Bright Data's Datasets v3 APIs, with LinkedIn endpoints."
  spec.homepage = "https://github.com/lucianghinda/brightdata"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.4.4"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata["documentation_uri"] = "https://rubydoc.info/gems/brightdata"
  spec.metadata["bug_tracker_uri"] = "#{spec.homepage}/issues"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir["lib/**/*.rb", "README.md", "LICENSE.txt", "CHANGELOG.md"]
  spec.require_paths = ["lib"]

  spec.add_dependency "simple-result", "~> 0.3.1"

  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rubocop", ">= 1.86.2"
  spec.add_development_dependency "webmock", "~> 3.0"
  spec.add_development_dependency "yard", "~> 0.9"
  spec.add_development_dependency "yard-markdown"
end
