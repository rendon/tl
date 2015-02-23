Given /^I translated the text "(.*?)" from "(.*?)" to "(.*?)" and cached the result$/ do |text, source, target|
  @text = text
  run "tli --cache_results --source #{source} --target #{target} #{text}"
  assert_success(true)
  @translation = Translation.find_google_translation(text, source, target)
  expect(@translation).to be_truthy
end

Then /^the translation should come from the local database$/ do
  expect { @translation.reload }.not_to change { @translation.updated_at }
end
