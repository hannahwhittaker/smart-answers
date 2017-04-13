
ENV["RAILS_ENV"] = "test"
ENV["GOVUK_APP_DOMAIN"] = "test.gov.uk"

require File.expand_path('../../config/environment', __FILE__)

if ENV["TEST_COVERAGE"]
  require 'simplecov'
  require 'simplecov-rcov'

  SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
  SimpleCov.start 'rails'
end

FLOW_REGISTRY_OPTIONS[:preload_flows] = true

require 'rails/test_help'

require 'mocha/setup'
Mocha::Configuration.prevent(:stubbing_non_existent_method)

require 'webmock/minitest'
WebMock.disable_net_connect!(allow_localhost: true)

class Minitest::Test
  def teardown_with_customisations
    teardown_without_customisations
    Timecop.return
    WorldLocation.reset_cache
  end
  alias_method_chain :teardown, :customisations
end

require 'gds_api/test_helpers/json_client_helper'
require_relative 'support/fixture_methods'
require_relative 'support/world_location_stubbing_methods'

class ActiveSupport::TestCase
  include FixtureMethods
  include WorldLocationStubbingMethods
end

require 'slimmer/test'
require 'slimmer/test_helpers/govuk_components'

class ActiveSupport::TestCase
  include Slimmer::TestHelpers::GovukComponents
end

class ActionController::TestCase
  include Slimmer::TestHelpers::GovukComponents
end

require 'govuk-content-schema-test-helpers/test_unit'

GovukContentSchemaTestHelpers.configure do |config|
  config.schema_type = 'publisher_v2'
  config.project_root = Rails.root
end

GovukAbTesting.configure do |config|
  config.acceptance_test_framework = :active_support
end
