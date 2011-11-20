Given /^we have cucumber support$/ do
  @cucumber = true
end

Given /^we do not have cucumber support$/ do
  @cucumber = false
end

Then /^doc tests should work$/ do
  @cucumber.should == true
end

Then /^(?:|I )should see JSON key "(.+)" with value "(.+)"$/ do |key, value|
  require 'json'
  hash = JSON.parse(page.source)
  key.split("/").each do |sub|
    raise "Unknown key: #{sub}" unless hash.is_a? Hash and hash.key?(sub)
    hash = hash[sub]
  end
  value = value.to_s unless value.nil?
  value = nil if value == "null"
  hash = hash.to_s unless hash.nil?
  hash.should == value
end