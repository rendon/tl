#require 'simplecov'
#SimpleCov.start
require 'coveralls'
Coveralls.wear!

require 'database_cleaner'

require 'tli'
require 'translators/google_translator'
require 'translators/translator'
require 'dictionaries/dictionary'
require 'dictionaries/google_dictionary'
require 'player'
require 'string_util'
require 'translation'
require 'webmock/rspec'

require_relative '../support/fake_google'

RSpec.configure do |config|

  config.before(:suite) do
    FileUtils.rm_rf(Dir.glob(Application.app_dir + '/pronunciations/*'))
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do |config|
    stub_request(:any, /translate.google.com/).to_rack(FakeGoogle)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
