Then /^it should fail with "(.*?)"$/ do |error_message|
  assert_failing_with(error_message)
end
