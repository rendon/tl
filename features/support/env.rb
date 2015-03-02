# require 'simplecov'
# SimpleCov.start
require 'coveralls'
Coveralls.wear!

require_relative '../../lib/translation'
require_relative '../../lib/application'

FileUtils.rm_rf(Dir.glob(Application.app_dir + '/pronunciations/*'))

Before do
  @aruba_timeout_seconds = 10
end
