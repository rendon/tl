Given /^this configuration file:$/ do |configuration|
  write_file Application.app_dir + '/tli.conf', configuration
end

When /^I run the translator with text "(.*?)"$/ do |text|
  run "tli #{text}"
end

When /^I run the translator with target "(.*?)" and text "(.*?)"$/ do |target, text|
  run "tli --target #{target} #{text}"
end
