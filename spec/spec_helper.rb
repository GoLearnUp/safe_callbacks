require 'rubygems'
require 'rspec'
require 'active_model'
require 'ruby-debug'

require File.join(File.dirname(__FILE__), '..', 'lib', 'safe_callbacks')

RSpec.configure do |config|
  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  config.raise_errors_for_deprecations!

  config.expect_with :rspec do |c|
    c.syntax = :should
  end
end
