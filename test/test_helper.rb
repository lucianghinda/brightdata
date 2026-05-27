# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "brightdata"
require "minitest/autorun"
require "webmock/minitest"

# Eager-load the whole gem so tests can reopen namespaces with short constant
# names, and so any Zeitwerk file/constant mismatch fails the suite loudly.
Zeitwerk::Loader.eager_load_all

if ENV["BRIGHTDATA_LIVE"]
  WebMock.disable_net_connect!(allow_localhost: true, allow: "api.brightdata.com")
else
  WebMock.disable_net_connect!(allow_localhost: true)
end

Dir[File.expand_path("live/support/**/*.rb", __dir__)].each { |file| require file }
