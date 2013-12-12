Given /^I have identified the book to buy$/ do
  user_selects_a_book_to_buy('summer')
end

Given /I have identified a best selling book to buy$/ do
  click_buy_now_best_seller_book
end

When /^I enter valid (.*?) card details$/ do |card_type|
  enter_new_payment_details(card_type)
end

And /^I enter valid Billing address$/ do
  enter_billing_details
end

And /^I submit payment details$/ do
  click_confirm_and_pay
end

When /^I pay with saved default card$/ do
  pay_with_saved_card
end

When /^I choose to pay with a new card$/ do
  click_pay_with_new_card
end

And /^I have identified a (free|pay for) book to (buy|read sample offline)$/ do |book_type,user_action|
  user_action = user_action.tr(" ","_")
  search_word = return_search_word_for_book_type(book_type)
 send("user_selects_a_book_to_#{user_action}", search_word)
end

When /^I click Confirm order$/ do
  click_confirm_order
end

Given /^I (?:am buying|click Buy now on) a (pay for|free) book as a (not logged|logged) in user$/ do |book_type, login_status|
  if login_status.eql?('logged')
    sign_in
  else
    if logged_in_session?
      log_out_current_session
    end
  end
  search_word = return_search_word_for_book_type(book_type)
  user_selects_a_book_to_buy(search_word)
end

When /^I pay with a new (.*?) card$/ do |card_type|
  click_pay_with_new_card
  enter_new_payment_details(card_type)
  enter_billing_details
end

And /^I choose (to save|not to save)(?: new)? payment details$/ do |save_payment|
  if save_payment.include?('not')
    choose_not_to_save_card_details
  else
    choose_to_save_card_details
  end

end

Then /^(?:my payment|adding sample) is successful$/ do
  expect_page_displayed('order complete')
  assert_order_complete
end

When /^I select Read offline on the book details page$/ do
click_read_offline
end
