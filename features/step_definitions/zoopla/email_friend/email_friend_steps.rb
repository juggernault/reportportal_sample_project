include EmailFriendElements

When(/^I fill in the email friend form details$/) do |table|
  $web.email_friend.fill_sender_data(table)
end

When(/^I click on Tell another friends link to add my friends email address (\d+)$/) do |number_of_friends|
  $web.email_friend.add_a_new_friend_email_field(number_of_friends)
end

When(/^I fill my friends email addresses (\d+)$/) do |number_of_friends|
  $web.email_friend.fill_friends_email(number_of_friends)
end

Then(/^I should see the following text within email friend form$/) do |table|
  within(EMAIL_FRIEND_FORM) do
    assert_true(Zpg.table_has_content?(table))
  end
end

Given(/^I navigate to listing details page$/) do
  visit("/for-sale/details/44632711/?disable_ads=1")
end

When(/^I click on the link (.*)/) do |link_text|
  Zpg.wait_for_dom_has_loaded
  link = find(:link, link_text)
  Zpg.scroll_to(link)
  link.click
end


When(/^I click on button (.*)$/) do |button|
  page.document.synchronize(20) do
    begin
      click_button button
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      log_message('Exception in finding button')
      click_button button
    end
  end
end

Then(/^I should see the succesful message (.*)$/) do |message|
  within('#content') do
    assert_true(Zpg.is_content_present?(message))
  end
end


Then(/^the browser's URL should contain the (.*)$/) do |path|
  Zpg.check_url_path(path)
end



