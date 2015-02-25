require 'database_cleaner'
require 'database_cleaner/cucumber'

DatabaseCleaner.strategy = :transaction

Before do
  @aruba_timeout_seconds = 7
end

Around do |scenario, block|
  DatabaseCleaner.cleaning(&block)
end
