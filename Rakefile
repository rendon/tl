require 'fileutils'

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

desc 'Run test suite.'
task :test do
  sh 'bundle exec rspec'
  sh 'bundle exec cucumber'
end
