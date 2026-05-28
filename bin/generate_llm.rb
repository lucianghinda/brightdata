#!/usr/bin/env ruby
# frozen_string_literal: true

# Assemble llm.md from YARD's markdown output.
#
# Reads the generated main-module doc (doc/BrightData.md), appends a
# "Documentation" section linking every other generated markdown page, then
# copies the result to llm.md at the repo root with repo-relative links.
#
# Run `yardoc --format=markdown` first (or use bin/prepare_release).

require "fileutils"

repo_root = File.expand_path("..", __dir__)
doc_dir = File.join(repo_root, "doc")
main_path = File.join(doc_dir, "BrightData.md")
llm_path = File.join(repo_root, "llm.md")

unless File.exist?(main_path)
  warn "Missing #{main_path} -- run `yardoc --format=markdown` first"
  exit 1
end

md_files = Dir.glob(File.join(doc_dir, "**", "*.md"))
md_files.reject! { |path| File.expand_path(path) == File.expand_path(main_path) }

links = md_files.map do |path|
  rel_path = path.sub("#{doc_dir}/", "")
  "- [#{rel_path}](#{rel_path})"
end

content = File.read(main_path)
content = content.sub(/# Documentation\s*\n[\s\S]*\z/, "") if content.match?(/^# Documentation\s*$/)
content = content.rstrip
content << "\n\n# Documentation\n\n"
content << links.join("\n")
content << "\n"

File.write(main_path, content)
puts "Updated #{main_path} (#{links.size} links)"

FileUtils.cp(main_path, llm_path)

# Rewrite every relative .md link so it resolves from the repo root (doc/...).
# YARD emits links like `[Foo](Foo.md)` or `[Foo](BrightData/Foo.md)`, which
# would 404 from llm.md at the repo root; prefix them with `doc/` unless they
# already start with a scheme, anchor, or absolute path.
llm_doc = File.read(llm_path)
llm_doc = llm_doc.gsub(/(\]\()([^)\s#]+\.md)([)#])/) do
  prefix, target, suffix = Regexp.last_match.values_at(1, 2, 3)
  if target.start_with?("doc/", "http://", "https://", "/")
    "#{prefix}#{target}#{suffix}"
  else
    "#{prefix}doc/#{target}#{suffix}"
  end
end
File.write(llm_path, llm_doc)
puts "Wrote #{llm_path}"
