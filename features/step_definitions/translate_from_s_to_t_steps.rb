Given /^I have the text "(.*?)"$/  do |text|
  @text = text
end

When /^I run the translator with S being "(.*?)" and T being "(.*?)"$/  do |source, target|
  run "tli --source #{source} --target #{target} --service google #{@text}"
end

Then /^I should see "(.*?)" in the output$/  do |translation|
  assert_passing_with translation
end

Given /^I started the translator with source "(.*?)", target "(.*?)", and no text$/ do |source, target|
  run_interactive "tli --source #{source} --target #{target} --service google"
end

When /^I enter "(.*?)"$/ do |text|
  type text
end

Then /^the program should output "(.*?)"$/ do |translation|
  assert_partial_output_interactive(translation)
end
