require 'fileutils'
require 'active_record'
require_relative 'lib/application'

task default: [:test]

desc 'Build tli gem.'
task :build do
  Rake::Task[:test].invoke

  dev_config = File.read('lib/config.rb')
  prod_config = dev_config.sub('env: :development', 'env: :production')
  File.open('lib/config.rb', 'w') { |f| f.write(prod_config) }

  sh 'gem build tli.gemspec'

  File.open('lib/config.rb', 'w') { |f| f.write(dev_config) }
end

desc 'Install tli gem.'
task :install do
  Rake::Task[:build].invoke
  sh 'gem install `ls tli-*`'
end

desc 'Prepare test test environment'
task :prepare_tests do
    FileUtils.rm_rf(Application.app_dir)
    FileUtils.mkdir_p(Application.app_dir + '/db')
    FileUtils.mkdir_p(Application.app_dir + '/pronunciations')
end

desc 'Run test suite.'
task :test do
  Rake::Task[:prepare_tests].invoke
  sh 'bundle exec rspec'
  sh 'bundle exec cucumber'
end
