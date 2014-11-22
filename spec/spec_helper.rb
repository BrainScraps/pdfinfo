if (ARGV & ["--line", "--example"]).empty? # skip focused tests
  require 'coveralls'
  Coveralls.wear! { add_filter "/spec/" }
end

require File.expand_path('../../lib/pdfinfo', __FILE__)

RSpec.configure do |config|
  config.expect_with :rspec
  config.mock_with :rspec
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.disable_monkey_patching!
  config.warnings = false

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  # config.profile_examples = 10

  config.order = :random

  Kernel.srand config.seed

  config.before(:each) do
    Pdfinfo.instance_variable_set(:@pdfinfo_command, nil)
  end

  module FixturePath
    def fixture_path(path)
      require 'pathname'
      Pathname.new(File.expand_path(File.join('../fixtures', path.to_s), __FILE__))
    end
    alias_method :fixture, :fixture_path
  end

  config.include FixturePath
end