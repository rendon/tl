#require 'simplecov'
#SimpleCov.start
require 'coveralls'
Coveralls.wear!

require_relative '../../lib/translation'
require_relative '../../lib/application'
require_relative '../../support/fake_google'
#require 'webmock/cucumber'

Before do
  FileUtils.rm_rf(Dir.glob(Application.app_dir + '/pronunciations/*'))
  @aruba_timeout_seconds = 10
  #WebMock.disable_net_connect!
  #stub_request(:any, /translate.google.com/).to_rack(FakeGoogle)
end
