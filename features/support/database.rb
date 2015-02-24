require 'database_cleaner'
require 'database_cleaner/cucumber'

DatabaseCleaner.strategy = :truncation

Before do
  @aruba_timeout_seconds = 5
end

Around do |scenario, block|
  DatabaseCleaner.cleaning(&block)
end
