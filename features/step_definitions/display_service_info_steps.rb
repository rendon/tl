Given /^I execute the program with \-\-info "(.*?)"$/ do |service|
  run "tli --info #{service}"
end
