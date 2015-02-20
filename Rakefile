require 'fileutils'

task :default => [:build]

desc "Build tli gem."
task :build do
  Rake::Task[:test].invoke
  sh 'gem build tli.gemspec'
end

desc "Install tli gem."
task :install do
  Rake::Task[:build].invoke
  sh 'gem install `ls tli-*`'
end

desc "Run test suite."
task :test do
  sh 'bundle exec rspec'
  sh 'bundle exec cucumber'
end
