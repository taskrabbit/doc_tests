Given /^we have cucumber support$/ do
  @cucumber = true
end

Given /^we do not have cucumber support$/ do
  @cucumber = false
end

Then /^doc tests should work$/ do
  @cucumber.should == true
end