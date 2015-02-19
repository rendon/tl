Given /^I have the text "(.*?)"$/  do |text|
  @text = text
end

When /^I run the translator with S being "(.*?)" and T being "(.*?)"$/  do |source, target|
  run 'tl --source #{source} --target #{target}'
end

Then /^I should see "(.*?)"$/  do |output|
  assert_passing_with output
end
