Given /^I am a guest user$/ do
  if logged_in_session?
  log_out_current_session
  end
end

Given /^I am not signed in$/ do
  delete_access_token_cookie
end

Given /^I have signed in$/ do
  sign_in(@email_address)
  assert_user_greeting_message_displayed
end

When /^(?:I sign in|sign in)(?: to proceed with purchase| to proceed with adding sample)?$/ do
  sign_in_from_redirected_page
end

Given /^I am on the Sign in page$/ do
  sign_in_page.load
end

When /^I (?:click|have selected) register (?:button|option)$/ do
  click_register_button
end


Given /^I am on Register page$/ do
  register_page.load
end

When /^I enter valid personal details$/ do
  @email_address, @first_name, @last_name = enter_personal_details
end

And /^I choose a valid password$/ do
  enter_password(test_data('passwords', 'valid_password'))
end

And /^I accept terms and conditions$/ do
  accept_terms_and_conditions(true)
end

And /^welcome message is shown$/ do
  registration_success_page.welcome_label.should have_content(get_message_text('Welcome'), :visible => true)
end

And /^I submit registration details$/ do
  submit_registration_details
end

When /^I enter valid sign in details$/ do
  email = test_data('emails', 'happypath_user')
  password = test_data('passwords', 'valid_password')
  @first_name = 'Happy-path'
  enter_sign_in_details(email, password)
end

And /^I click sign in button$/ do
  click_sign_in_button
end

Then /^I am successfully signed in$/ do
  assert_user_greeting_message_displayed(@first_name)
end

And /^I am redirected to (.*?) page$/ do |page_name|
  expect_page_displayed(page_name)
end

Given /^I am on my account page$/ do
  click_link_from_my_account_dropdown('Personal details')
end

And /^I click Sign out button$/ do
  click_button('Sign out')
end

Then /^I should be signed out successfully$/ do
  assert_user_greeting_message_not_displayed
  assert_cookie_value('access_token', nil)
end

Given /^I have multiple stored cards$/ do
  @email_address = test_data('emails', 'multiple_storedcards')
end

Given /^I register(?: to proceed with purchase| to proceed with adding sample)?$/ do
  click_register_button
  register_new_user
end

Given /^I have default expired stored card$/ do
 set_email_and_password(test_data('emails', 'one_default_expired_card'), test_data('passwords', 'valid_password'))
end

Given /^I have multiple saved cards with (default|non-default) card expired$/ do |expired_card|
  if (expired_card.include?('non'))
    email_address = test_data('emails', 'multiple_cards_non_default_expired')
  else
    email_address = test_data('emails', 'multiple_cards_default_expired')
  end
  set_email_and_password(email_address, test_data('passwords', 'valid_password'))
end

When /^I enter personal details with (valid|invalid) clubcard number$/ do |club_card_type|
  club_card = test_data('clubcards', 'valid_clubcard_number')
  if club_card_type.include?('invalid')
    club_card = test_data('clubcards', 'invalid_clubcard_number')
  end
  @email_address, @first_name, @last_name = enter_personal_details
  register_page.fill_in_club_card(club_card)
end

And /^I submit registration details by (accepting|not accepting) terms and conditions$/ do |accept_terms|
  if accept_terms.include?('not')
    accept_terms_and_conditions(false)
  else
    accept_terms_and_conditions(true)
  end
  submit_registration_details
end

When /^I enter registration details with already registered email address$/ do
  @email_address, @first_name, @last_name = enter_personal_details(test_data('emails', 'happypath_user'))
  enter_password(test_data('passwords', 'valid_password'))
end

Then /^registration is not successful$/ do
  expect_page_displayed('Register')
end

When /^I enter valid registration details$/ do
  @email_address, @first_name, @last_name = enter_personal_details
  enter_password(test_data('passwords', 'valid_password'))
end

And(/^link to sign in with already registered email address is displayed$/) do
  register_page.sign_email_link.text.should include(@email_address)
end

And /^type passwords that are less than 6 characters$/ do
  enter_password('test1')
end

And /^type passwords that are not matching$/ do
  register_page.password.set test_data('passwords', 'valid_password')
  register_page.password_repeat.set test_data('passwords', 'not_matching_password')
end

But /^I leave the password field empty$/ do
  enter_password('')
end

Then /^sign in is not successful$/ do
  expect_page_displayed('sign in')
end

When /^I try to sign in with email address that is not registered$/ do
  submit_sign_in_details(generate_random_email_address, test_data('passwords', 'valid_password'))
end

And /^link to reset password is displayed$/ do
   sign_in_page.send_reset_link.should
end

When /^I (?:try|have attempted) to sign in with incorrect password$/ do
  submit_sign_in_details(test_data('emails', 'happypath_user'), test_data('passwords', 'not_matching_password'))
end

When /^I try to sign in with empty password field$/ do
  submit_sign_in_details(test_data('emails', 'happypath_user'),'')
end

When /^I click on Send me a reset link$/ do
  sign_in_page.send_reset_link.click
end

Given /^I am returning user(?: with saved payment details)?$/ do
  set_email_and_password(test_data('emails', 'no_expired_cards'), test_data('passwords', 'valid_password'))
end

Given /^I have attempted to register with already registered email address$/ do
  @email_address, @first_name, @last_name = enter_personal_details(test_data('emails', 'happypath_user'))
  enter_password(test_data('passwords', 'valid_password'))
  accept_terms_and_conditions(true)
  submit_registration_details
end

When /^I click on link to sign in with already registered email$/ do
 register_page.sign_email_link.click
end

Given /^I have a (?:pay for|free) (?:book|book sample) in my library$/ do
  set_email_and_password(test_data('emails', 'books_in_library'), test_data('passwords', 'valid_password'))
end

Given /^I am returning user with no (?:associated devices|saved payment cards|orders in the past)$/ do
  set_email_and_password(test_data('emails', 'empty_library_no_devices'), test_data('passwords', 'valid_password'))
end

Given /^I have (not opted|opted) in for blinkbox books marketing$/ do |opt_status|
  if opt_status.include? ('not')
    set_email_and_password(test_data('emails', 'opted_out_marketing'), test_data('passwords', 'valid_password'))
  else
    set_email_and_password(test_data('emails', 'opted_in_marketing'), test_data('passwords', 'valid_password'))
  end
end

When /^I click on Forgotton your password\? link$/ do
  sign_in_page.forgotten_password_link.click
end

When /^I enter "(.*?)" for email address$/ do |reset_password_email|
  @reset_email = reset_password_email
   reset_password_page.email_address.set @reset_email
end

And /^click send reset link button$/  do
  reset_password_page.send_reset_link.click
end

And /^reset email confirmation message is displayed$/  do
  reset_password_response_page.should have_email_confirm_message
  reset_password_response_page.assert_reset_password_message @reset_email
end

