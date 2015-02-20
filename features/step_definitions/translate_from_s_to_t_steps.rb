Given /^I have the text "(.*?)"$/  do |text|
  @text = text
end

When /^I run the translator with S being "(.*?)" and T being "(.*?)"$/  do |source, target|
  run "tli --source #{source} --target #{target} --service google #{@text}"
end

Then /^I should see "(.*?)" in the output$/  do |translation|
  assert_passing_with translation
end
