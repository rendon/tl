Given (/^I run the application with options "(.*?)"$/) do |options|
	run "tli #{options}"
end

Then (/^the application should fail with "(.*?)"$/) do |error_message|
	assert_failing_with(error_message)
end
